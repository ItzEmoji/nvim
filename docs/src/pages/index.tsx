import React from 'react';
import {Redirect} from '@docusaurus/router';

// The docs plugin is mounted at `/docs` (see `routeBasePath` in
// docusaurus.config.ts), so nothing serves the site root. Without this page,
// the navbar's home link (which always points at `baseUrl`) is broken on
// every page, and `onBrokenLinks: 'throw'` fails the build.
export default function Home(): React.ReactElement {
  return <Redirect to="/docs/" />;
}
