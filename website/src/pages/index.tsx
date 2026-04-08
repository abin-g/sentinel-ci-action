import React from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';

import styles from './index.module.css';

const platformHighlights = [
  {
    title: 'Signal over noise',
    description:
      'Prioritize actionable risks with AI-assisted pull request analysis instead of flooding teams with low-value alerts.',
  },
  {
    title: 'Policy-backed enforcement',
    description:
      'Turn architectural standards, naming rules, and security gates into versioned checks inside your repository.',
  },
  {
    title: 'Practical adoption path',
    description:
      'Start with a quick installer, then layer in AI providers, diff-aware scans, and optional deep analysis as needed.',
  },
];

const docSections = [
  {
    title: 'Guides',
    href: '/docs/category/guides',
    description: 'Installation, setup, and troubleshooting for real repository rollout.',
  },
  {
    title: 'Features',
    href: '/docs/category/features',
    description: 'Diff-aware scanning, dependency analysis, policy packs, and CodeQL improvements.',
  },
  {
    title: 'Reference',
    href: '/docs/category/reference',
    description: 'Rule engine details, feature reference, and error code behavior.',
  },
  {
    title: 'Architecture',
    href: '/docs/category/architecture',
    description: 'How Sentinel CI is structured and how the analysis flow works.',
  },
];

const installSteps = [
  'Add the GitHub Action to your repository workflow.',
  'Create a .sentinel-ci.yml policy file for your standards and severity thresholds.',
  'Open a pull request and verify the PR comment, permissions, and findings output.',
];

function HomepageHeader(): JSX.Element {
  const {siteConfig} = useDocusaurusContext();

  return (
    <header className={clsx(styles.heroBanner)}>
      <div className={clsx('container', styles.heroGrid)}>
        <div className={styles.heroCopy}>
          <p className={styles.eyebrow}>Open-source PR security and governance</p>
          <h1 className={styles.heroTitle}>{siteConfig.title}</h1>
          <p className={styles.heroSubtitle}>{siteConfig.tagline}</p>
          <p className={styles.heroDescription}>
            Sentinel CI brings AI-assisted security review, dependency risk checks,
            architecture rules, and policy-based merge gates into one pull-request
            workflow.
          </p>
          <div className={styles.heroActions}>
            <Link className="button button--primary button--lg" to="/docs">
              Explore Documentation
            </Link>
            <Link
              className="button button--secondary button--lg"
              to="/docs/guides/INSTALLATION">
              Quick Install
            </Link>
          </div>
        </div>
        <div className={styles.heroPanel}>
          <div className={styles.panelHeader}>Quickstart</div>
          <pre className={styles.codePanel}>
            <code>{`curl -sL https://raw.githubusercontent.com/abin-g/sentinel-ci-action/master/scripts/setup.sh -o setup.sh
chmod +x setup.sh && ./setup.sh`}</code>
          </pre>
          <div className={styles.panelMeta}>
            Install quickly, then refine rules, AI providers, and enforcement depth from the docs.
          </div>
        </div>
      </div>
    </header>
  );
}

function HighlightSection(): JSX.Element {
  return (
    <section className={styles.section}>
      <div className="container">
        <div className={styles.sectionHeading}>
          <p className={styles.sectionLabel}>Why teams adopt it</p>
          <h2>Security checks that match how repositories actually evolve</h2>
        </div>
        <div className={styles.cardGrid}>
          {platformHighlights.map((item) => (
            <article key={item.title} className={styles.infoCard}>
              <h3>{item.title}</h3>
              <p>{item.description}</p>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}

function DocsSection(): JSX.Element {
  return (
    <section className={clsx(styles.section, styles.sectionAlt)}>
      <div className="container">
        <div className={styles.sectionHeading}>
          <p className={styles.sectionLabel}>Documentation</p>
          <h2>Every current repository doc is available in the website</h2>
        </div>
        <div className={styles.cardGrid}>
          {docSections.map((section) => (
            <Link key={section.title} to={section.href} className={styles.docCard}>
              <span className={styles.docCardTitle}>{section.title}</span>
              <span className={styles.docCardText}>{section.description}</span>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}

function InstallSection(): JSX.Element {
  return (
    <section className={styles.section}>
      <div className={clsx('container', styles.installLayout)}>
        <div>
          <p className={styles.sectionLabel}>Adoption path</p>
          <h2 className={styles.installTitle}>From install to enforced policy in one flow</h2>
          <ol className={styles.stepList}>
            {installSteps.map((step) => (
              <li key={step}>{step}</li>
            ))}
          </ol>
        </div>
        <div className={styles.installLinks}>
          <Link
            className={styles.inlineCard}
            to="/docs/guides/SETUP">
            <strong>Manual setup guide</strong>
            <span>Configure the action and policy file by hand.</span>
          </Link>
          <Link
            className={styles.inlineCard}
            to="/docs/reference/RULE_ENGINE">
            <strong>Rule engine reference</strong>
            <span>Define merge-blocking rules, standards, and severity handling.</span>
          </Link>
          <Link
            className={styles.inlineCard}
            to="/docs/guides/TROUBLESHOOTING">
            <strong>Troubleshooting</strong>
            <span>Resolve workflow, permissions, AI provider, and CodeQL issues.</span>
          </Link>
        </div>
      </div>
    </section>
  );
}

export default function Home(): JSX.Element {
  const {siteConfig} = useDocusaurusContext();

  return (
    <Layout
      title={siteConfig.title}
      description="Public landing page and documentation portal for Sentinel CI.">
      <HomepageHeader />
      <main>
        <HighlightSection />
        <DocsSection />
        <InstallSection />
      </main>
    </Layout>
  );
}
