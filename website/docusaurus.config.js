// @ts-check

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Sentinel CI',
  tagline: 'AI-native DevSecOps guardrails for pull requests',
  favicon: 'img/logo.svg',

  url: 'https://abin-g.github.io',
  baseUrl: '/sentinel-ci-action/',

  organizationName: 'abin-g',
  projectName: 'sentinel-ci-action',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          path: '../docs',
          routeBasePath: 'docs',
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/abin-g/sentinel-ci-action/tree/master/',
        },
        blog: false,
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      image: 'img/social-card.svg',
      navbar: {
        title: 'Sentinel CI',
        logo: {
          alt: 'Sentinel CI Logo',
          src: 'img/logo.svg',
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'docsSidebar',
            position: 'left',
            label: 'Docs',
          },
          {to: '/docs/category/guides', label: 'Guides', position: 'left'},
          {to: '/docs/category/features', label: 'Features', position: 'left'},
          {
            href: 'https://github.com/abin-g/sentinel-ci-action',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              {
                label: 'Documentation',
                to: '/docs',
              },
              {
                label: 'Installation',
                to: '/docs/guides/INSTALLATION',
              },
              {
                label: 'Troubleshooting',
                to: '/docs/guides/TROUBLESHOOTING',
              },
            ],
          },
          {
            title: 'Project',
            items: [
              {
                label: 'Architecture',
                to: '/docs/architecture/TECHNICAL_DETAILS',
              },
              {
                label: 'Rule Engine',
                to: '/docs/reference/RULE_ENGINE',
              },
              {
                label: 'Roadmap',
                to: '/docs/roadmap/',
              },
            ],
          },
          {
            title: 'Open Source',
            items: [
              {
                label: 'GitHub Repository',
                href: 'https://github.com/abin-g/sentinel-ci-action',
              },
              {
                label: 'Issues',
                href: 'https://github.com/abin-g/sentinel-ci-action/issues',
              },
              {
                label: 'License',
                to: '/docs/legal/LICENSE',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Sentinel CI. Built with Docusaurus.`,
      },
      colorMode: {
        defaultMode: 'light',
        respectPrefersColorScheme: true,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
        additionalLanguages: ['bash', 'yaml', 'diff'],
      },
    }),
};

module.exports = config;
