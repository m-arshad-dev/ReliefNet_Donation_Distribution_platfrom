const TEMPLATES = [
  {
    roleName: 'donor',
    name: 'Donor Onboarding',
    slug: 'donor_onboarding',
    requiresApproval: false,
    steps: [
      {
        key: 'basic_info',
        order: 1,
        schema: {
          fields: [
            { name: 'full_name', type: 'text', required: true },
            { name: 'email', type: 'email', required: true },
            { name: 'phone', type: 'text' },
          ],
        },
      },
      {
        key: 'preferences',
        order: 2,
        schema: {
          fields: [
            { name: 'donation_type', type: 'select', options: ['money', 'goods'] },
            { name: 'frequency', type: 'select', options: ['one_time', 'monthly'] },
          ],
        },
      },
    ],
  },
  {
    roleName: 'volunteer',
    name: 'Volunteer Onboarding',
    slug: 'volunteer_onboarding',
    requiresApproval: false,
    steps: [
      {
        key: 'basic_info',
        order: 1,
        schema: {
          fields: [
            { name: 'full_name', type: 'text', required: true },
            { name: 'email', type: 'email', required: true },
            { name: 'phone', type: 'text' },
          ],
        },
      },
      {
        key: 'skills',
        order: 2,
        schema: {
          fields: [
            { name: 'skills', type: 'multi_select', required: true },
            { name: 'experience_years', type: 'number' },
          ],
        },
      },
      {
        key: 'availability',
        order: 3,
        schema: {
          fields: [
            { name: 'days_available', type: 'multi_select', required: true },
            { name: 'hours_per_week', type: 'number' },
          ],
        },
      },
    ],
  },
  {
    roleName: 'beneficiary',
    name: 'Beneficiary Onboarding',
    slug: 'beneficiary_onboarding',
    requiresApproval: false,
    steps: [
      {
        key: 'identity',
        order: 1,
        schema: {
          fields: [
            { name: 'full_name', type: 'text', required: true },
            { name: 'national_id', type: 'text', required: true },
            { name: 'phone', type: 'text' },
          ],
        },
      },
      {
        key: 'needs',
        order: 2,
        schema: {
          fields: [
            { name: 'need_type', type: 'select', options: ['food', 'medical', 'education'], required: true },
            { name: 'description', type: 'textarea' },
          ],
        },
      },
      {
        key: 'location',
        order: 3,
        schema: {
          fields: [
            { name: 'city', type: 'text', required: true },
            { name: 'address', type: 'text' },
          ],
        },
      },
    ],
  },
  {
    roleName: 'ngo_admin',
    name: 'NGO Onboarding',
    slug: 'ngo_onboarding',
    requiresApproval: true,
    steps: [
      {
        key: 'org_info',
        order: 1,
        schema: {
          fields: [
            { name: 'org_name', type: 'text', required: true },
            { name: 'registration_number', type: 'text', required: true },
          ],
        },
      },
      {
        key: 'documents',
        order: 2,
        schema: {
          fields: [
            { name: 'license_doc', type: 'file', required: true },
            { name: 'tax_doc', type: 'file', required: true },
          ],
        },
      },
      {
        key: 'verification',
        order: 3,
        schema: {
          fields: [
            { name: 'website', type: 'text' },
            { name: 'description', type: 'textarea' },
          ],
        },
      },
    ],
  },
];

function sqlEscape(value) {
  return value.replace(/'/g, "''");
}

export const up = (pgm) => {
  for (const template of TEMPLATES) {
    pgm.sql(`
      INSERT INTO onboarding_templates
        (role_id, name, slug, version, is_default, requires_approval, is_active)
      VALUES
        ((SELECT id FROM roles WHERE name = '${sqlEscape(template.roleName)}'),
         '${sqlEscape(template.name)}',
         '${sqlEscape(template.slug)}',
         1,
         true,
         ${template.requiresApproval},
         true)
      ON CONFLICT (slug) DO NOTHING;
    `);

    for (const step of template.steps) {
      pgm.sql(`
        INSERT INTO onboarding_template_steps
          (template_id, step_key, step_order, is_required, input_schema, config)
        VALUES
          (
            (SELECT id FROM onboarding_templates WHERE slug = '${sqlEscape(template.slug)}'),
            '${sqlEscape(step.key)}',
            ${step.order},
            true,
            '${JSON.stringify(step.schema)}',
            '{}'
          )
        ON CONFLICT DO NOTHING;
      `);
    }
  }
};

export const down = (pgm) => {
  const seededSlugs = TEMPLATES.map(({ slug }) => `'${sqlEscape(slug)}'`).join(', ');

  pgm.sql(`
    DELETE FROM onboarding_template_steps
    WHERE template_id IN (
      SELECT id FROM onboarding_templates
      WHERE slug IN (${seededSlugs})
    );

    DELETE FROM onboarding_templates
    WHERE slug IN (${seededSlugs});
  `);
};
