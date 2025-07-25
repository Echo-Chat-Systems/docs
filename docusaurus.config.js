// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import {themes as prismThemes} from 'prism-react-renderer';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/** @type {import('@docusaurus/types').Config} */
const config = {
    title: 'Echo-Chat Docs',
    tagline: 'Open Source Communication',
    favicon: 'https://static.echo-chat.au/res/favicon.ico',

    // Future flags, see https://docusaurus.io/docs/api/docusaurus-config#future
    future: {
        v4: true, // Improve compatibility with the upcoming Docusaurus v4
    },

    // Set the production url of your site here
    url: 'https://docs.echo-chat.au',
    // Set the /<baseUrl>/ pathname under which your site is served
    // For GitHub pages deployment, it is often '/<projectName>/'
    baseUrl: '/',

    // GitHub pages deployment config.
    // If you aren't using GitHub pages, you don't need these.
    organizationName: 'Echo-Chat-Sytems', // Usually your GitHub org/user name.
    projectName: 'Echo-Chat', // Usually your repo name.

    onBrokenLinks: 'throw',
    onBrokenMarkdownLinks: 'warn',

    // Even if you don't use internationalization, you can use this field to set
    // useful metadata like html lang. For example, if your site is Chinese, you
    // may want to replace "en" with "zh-Hans".
    i18n: {
        defaultLocale: 'en',
        locales: ['en'],
    },

    presets: [
        [
            'classic',
            /** @type {import('@docusaurus/preset-classic').Options} */
            ({
                docs: {
                    sidebarPath: './sidebars.js',
                    // Please change this to your repo.
                    // Remove this to remove the "edit this page" links.
                    /// editUrl: 'https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/',
                },
                theme: {
                    customCss: './src/css/custom.css',
                },
            }),
        ],
    ],

    themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
        ({
            // Replace with your project's social card
            image: 'https://static.echo-chat.au/res/icon.png',
            colorMode: {
                respectPrefersColorScheme: true
            },
            navbar: {
                title: 'Echo-Chat Docs',
                logo: {
                    alt: 'Ech-Chat Logo',
                    src: 'https://static.echo-chat.au/res/logo.svg',
                },
                items: [
                    {
                        label: 'Tutorial',
                        type: 'docSidebar',
                        sidebarId: 'tutorialSidebar',
                        position: 'left',
                    },
                    {
                        label: 'Protocol',
                        type: 'docSidebar',
                        sidebarId: 'protocolSidebar',
                        position: 'left'
                    },
                    {
                        href: 'https://github.com/Echo-Chat-Systems/',
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
                                label: 'Tutorial',
                                to: '/docs/tutorial/intro',
                            },
                            {
                                label: 'Protocol',
                                to: '/docs/protocol/'
                            }
                        ],
                    },
                    {
                        title: 'Community',
                        items: [

                        ],
                    },
                    {
                        title: 'More',
                        items: [
                            {
                                label: 'GitHub',
                                href: 'https://github.com/Echo-Chat-Systems/',
                            },
                        ],
                    },
                ],
                copyright: `Copyright © ${new Date().getFullYear()} Echo-Chat Systems. Built with Docusaurus.`,
            },
            prism: {
                theme: prismThemes.github,
                darkTheme: prismThemes.dracula,
            },
        }),
};

export default config;
