/* Nutkit */

/**
 *  Bootstrap 4 Grid System implementation
*/

.nk-container {
    width: 100%;
    /*padding-right: 1rem;*/
    /*padding-left: 1rem;*/
    margin-right: auto;
    margin-left: auto;
    padding: 50px 0;}
@media (min-width: 524px) {
    .nk-container {
        max-width: 540px; } }
@media (min-width: 768px) {
    .nk-container {
        max-width: 720px; } }
@media (min-width: 1024px) {
    .nk-container {
        max-width: 960px; } }
@media (min-width: 1280px) {
    .nk-container {
        max-width: 1140px; } }

.nk-container-fluid {
    width: 100%;
    padding-right: 1rem;
    padding-left: 1rem;
    margin-right: auto;
    margin-left: auto; }

.nk-row {
    display: flex;
    flex-wrap: wrap;
    margin-right: -1rem;
    margin-left: -1rem; }

.no-gutters {
    margin-right: 0;
    margin-left: 0; }
.no-gutters > .nk-col,
.no-gutters > [class*="col-"] {
    padding-right: 0;
    padding-left: 0; }

.nk-col-1, .nk-col-2, .nk-col-3, .nk-col-4, .nk-col-5, .nk-col-6, .nk-col-7, .nk-col-8, .nk-col-9, .nk-col-10, .nk-col-11, .nk-col-12, .nk-col,
.nk-col-auto, .nk-col-sm-1, .nk-col-sm-2, .nk-col-sm-3, .nk-col-sm-4, .nk-col-sm-5, .nk-col-sm-6, .nk-col-sm-7, .nk-col-sm-8, .nk-col-sm-9, .nk-col-sm-10, .nk-col-sm-11, .nk-col-sm-12, .nk-col-sm,
.nk-col-sm-auto, .nk-col-md-1, .nk-col-md-2, .nk-col-md-3, .nk-col-md-4, .nk-col-md-5, .nk-col-md-6, .nk-col-md-7, .nk-col-md-8, .nk-col-md-9, .nk-col-md-10, .nk-col-md-11, .nk-col-md-12, .nk-col-md,
.nk-col-md-auto, .nk-col-lg-1, .nk-col-lg-2, .nk-col-lg-3, .nk-col-lg-4, .nk-col-lg-5, .nk-col-lg-6, .nk-col-lg-7, .nk-col-lg-8, .nk-col-lg-9, .nk-col-lg-10, .nk-col-lg-11, .nk-col-lg-12, .nk-col-lg,
.nk-col-lg-auto, .nk-col-xl-1, .nk-col-xl-2, .nk-col-xl-3, .nk-col-xl-4, .nk-col-xl-5, .nk-col-xl-6, .nk-col-xl-7, .nk-col-xl-8, .nk-col-xl-9, .nk-col-xl-10, .nk-col-xl-11, .nk-col-xl-12, .nk-col-xl,
.nk-col-xl-auto {
    position: relative;
    width: 100%;
    padding-right: 1rem;
    padding-left: 1rem; }

.nk-col {
    flex-basis: 0;
    flex-grow: 1;
    max-width: 100%; }

.nk-col-auto {
    flex: 0 0 auto;
    width: auto;
    max-width: 100%; }

.nk-col-1 {
    flex: 0 0 8.33333%;
    max-width: 8.33333%; }

.nk-col-2 {
    flex: 0 0 16.66667%;
    max-width: 16.66667%; }

.nk-col-3 {
    flex: 0 0 25%;
    max-width: 25%; }

.nk-col-4 {
    flex: 0 0 33.33333%;
    max-width: 33.33333%; }

.nk-col-5 {
    flex: 0 0 41.66667%;
    max-width: 41.66667%; }

.nk-col-6 {
    flex: 0 0 50%;
    max-width: 50%; }

.nk-col-7 {
    flex: 0 0 58.33333%;
    max-width: 58.33333%; }

.nk-col-8 {
    flex: 0 0 66.66667%;
    max-width: 66.66667%; }

.nk-col-9 {
    flex: 0 0 75%;
    max-width: 75%; }

.nk-col-10 {
    flex: 0 0 83.33333%;
    max-width: 83.33333%; }

.nk-col-11 {
    flex: 0 0 91.66667%;
    max-width: 91.66667%; }

.nk-col-12 {
    flex: 0 0 100%;
    max-width: 100%; }

.order-first {
    order: -1; }

.order-last {
    order: 13; }

.order-0 {
    order: 0; }

.order-1 {
    order: 1; }

.order-2 {
    order: 2; }

.order-3 {
    order: 3; }

.order-4 {
    order: 4; }

.order-5 {
    order: 5; }

.order-6 {
    order: 6; }

.order-7 {
    order: 7; }

.order-8 {
    order: 8; }

.order-9 {
    order: 9; }

.order-10 {
    order: 10; }

.order-11 {
    order: 11; }

.order-12 {
    order: 12; }

.offset-1 {
    margin-left: 8.33333%; }

.offset-2 {
    margin-left: 16.66667%; }

.offset-3 {
    margin-left: 25%; }

.offset-4 {
    margin-left: 33.33333%; }

.offset-5 {
    margin-left: 41.66667%; }

.offset-6 {
    margin-left: 50%; }

.offset-7 {
    margin-left: 58.33333%; }

.offset-8 {
    margin-left: 66.66667%; }

.offset-9 {
    margin-left: 75%; }

.offset-10 {
    margin-left: 83.33333%; }

.offset-11 {
    margin-left: 91.66667%; }

@media (min-width: 524px) {
    .nk-col-sm {
        flex-basis: 0;
        flex-grow: 1;
        max-width: 100%; }
    .nk-col-sm-auto {
        flex: 0 0 auto;
        width: auto;
        max-width: 100%; }
    .nk-col-sm-1 {
        flex: 0 0 8.33333%;
        max-width: 8.33333%; }
    .nk-col-sm-2 {
        flex: 0 0 16.66667%;
        max-width: 16.66667%; }
    .nk-col-sm-3 {
        flex: 0 0 25%;
        max-width: 25%; }
    .nk-col-sm-4 {
        flex: 0 0 33.33333%;
        max-width: 33.33333%; }
    .nk-col-sm-5 {
        flex: 0 0 41.66667%;
        max-width: 41.66667%; }
    .nk-col-sm-6 {
        flex: 0 0 50%;
        max-width: 50%; }
    .nk-col-sm-7 {
        flex: 0 0 58.33333%;
        max-width: 58.33333%; }
    .nk-col-sm-8 {
        flex: 0 0 66.66667%;
        max-width: 66.66667%; }
    .nk-col-sm-9 {
        flex: 0 0 75%;
        max-width: 75%; }
    .nk-col-sm-10 {
        flex: 0 0 83.33333%;
        max-width: 83.33333%; }
    .nk-col-sm-11 {
        flex: 0 0 91.66667%;
        max-width: 91.66667%; }
    .nk-col-sm-12 {
        flex: 0 0 100%;
        max-width: 100%; }
    .order-sm-first {
        order: -1; }
    .order-sm-last {
        order: 13; }
    .order-sm-0 {
        order: 0; }
    .order-sm-1 {
        order: 1; }
    .order-sm-2 {
        order: 2; }
    .order-sm-3 {
        order: 3; }
    .order-sm-4 {
        order: 4; }
    .order-sm-5 {
        order: 5; }
    .order-sm-6 {
        order: 6; }
    .order-sm-7 {
        order: 7; }
    .order-sm-8 {
        order: 8; }
    .order-sm-9 {
        order: 9; }
    .order-sm-10 {
        order: 10; }
    .order-sm-11 {
        order: 11; }
    .order-sm-12 {
        order: 12; }
    .offset-sm-0 {
        margin-left: 0; }
    .offset-sm-1 {
        margin-left: 8.33333%; }
    .offset-sm-2 {
        margin-left: 16.66667%; }
    .offset-sm-3 {
        margin-left: 25%; }
    .offset-sm-4 {
        margin-left: 33.33333%; }
    .offset-sm-5 {
        margin-left: 41.66667%; }
    .offset-sm-6 {
        margin-left: 50%; }
    .offset-sm-7 {
        margin-left: 58.33333%; }
    .offset-sm-8 {
        margin-left: 66.66667%; }
    .offset-sm-9 {
        margin-left: 75%; }
    .offset-sm-10 {
        margin-left: 83.33333%; }
    .offset-sm-11 {
        margin-left: 91.66667%; } }

@media (min-width: 768px) {
    .nk-col-md {
        flex-basis: 0;
        flex-grow: 1;
        max-width: 100%; }
    .nk-col-md-auto {
        flex: 0 0 auto;
        width: auto;
        max-width: 100%; }
    .nk-col-md-1 {
        flex: 0 0 8.33333%;
        max-width: 8.33333%; }
    .nk-col-md-2 {
        flex: 0 0 16.66667%;
        max-width: 16.66667%; }
    .nk-col-md-3 {
        flex: 0 0 25%;
        max-width: 25%; }
    .nk-col-md-4 {
        flex: 0 0 33.33333%;
        max-width: 33.33333%; }
    .nk-col-md-5 {
        flex: 0 0 41.66667%;
        max-width: 41.66667%; }
    .nk-col-md-6 {
        flex: 0 0 50%;
        max-width: 50%; }
    .nk-col-md-7 {
        flex: 0 0 58.33333%;
        max-width: 58.33333%; }
    .nk-col-md-8 {
        flex: 0 0 66.66667%;
        max-width: 66.66667%; }
    .nk-col-md-9 {
        flex: 0 0 75%;
        max-width: 75%; }
    .nk-col-md-10 {
        flex: 0 0 83.33333%;
        max-width: 83.33333%; }
    .nk-col-md-11 {
        flex: 0 0 91.66667%;
        max-width: 91.66667%; }
    .nk-col-md-12 {
        flex: 0 0 100%;
        max-width: 100%; }
    .order-md-first {
        order: -1; }
    .order-md-last {
        order: 13; }
    .order-md-0 {
        order: 0; }
    .order-md-1 {
        order: 1; }
    .order-md-2 {
        order: 2; }
    .order-md-3 {
        order: 3; }
    .order-md-4 {
        order: 4; }
    .order-md-5 {
        order: 5; }
    .order-md-6 {
        order: 6; }
    .order-md-7 {
        order: 7; }
    .order-md-8 {
        order: 8; }
    .order-md-9 {
        order: 9; }
    .order-md-10 {
        order: 10; }
    .order-md-11 {
        order: 11; }
    .order-md-12 {
        order: 12; }
    .offset-md-0 {
        margin-left: 0; }
    .offset-md-1 {
        margin-left: 8.33333%; }
    .offset-md-2 {
        margin-left: 16.66667%; }
    .offset-md-3 {
        margin-left: 25%; }
    .offset-md-4 {
        margin-left: 33.33333%; }
    .offset-md-5 {
        margin-left: 41.66667%; }
    .offset-md-6 {
        margin-left: 50%; }
    .offset-md-7 {
        margin-left: 58.33333%; }
    .offset-md-8 {
        margin-left: 66.66667%; }
    .offset-md-9 {
        margin-left: 75%; }
    .offset-md-10 {
        margin-left: 83.33333%; }
    .offset-md-11 {
        margin-left: 91.66667%; } }

@media (min-width: 1024px) {
    .nk-col-lg {
        flex-basis: 0;
        flex-grow: 1;
        max-width: 100%; }
    .nk-col-lg-auto {
        flex: 0 0 auto;
        width: auto;
        max-width: 100%; }
    .nk-col-lg-1 {
        flex: 0 0 8.33333%;
        max-width: 8.33333%; }
    .nk-col-lg-2 {
        flex: 0 0 16.66667%;
        max-width: 16.66667%; }
    .nk-col-lg-3 {
        flex: 0 0 25%;
        max-width: 25%; }
    .nk-col-lg-4 {
        flex: 0 0 33.33333%;
        max-width: 33.33333%; }
    .nk-col-lg-5 {
        flex: 0 0 41.66667%;
        max-width: 41.66667%; }
    .nk-col-lg-6 {
        flex: 0 0 50%;
        max-width: 50%; }
    .nk-col-lg-7 {
        flex: 0 0 58.33333%;
        max-width: 58.33333%; }
    .nk-col-lg-8 {
        flex: 0 0 66.66667%;
        max-width: 66.66667%; }
    .nk-col-lg-9 {
        flex: 0 0 75%;
        max-width: 75%; }
    .nk-col-lg-10 {
        flex: 0 0 83.33333%;
        max-width: 83.33333%; }
    .nk-col-lg-11 {
        flex: 0 0 91.66667%;
        max-width: 91.66667%; }
    .nk-col-lg-12 {
        flex: 0 0 100%;
        max-width: 100%; }
    .order-lg-first {
        order: -1; }
    .order-lg-last {
        order: 13; }
    .order-lg-0 {
        order: 0; }
    .order-lg-1 {
        order: 1; }
    .order-lg-2 {
        order: 2; }
    .order-lg-3 {
        order: 3; }
    .order-lg-4 {
        order: 4; }
    .order-lg-5 {
        order: 5; }
    .order-lg-6 {
        order: 6; }
    .order-lg-7 {
        order: 7; }
    .order-lg-8 {
        order: 8; }
    .order-lg-9 {
        order: 9; }
    .order-lg-10 {
        order: 10; }
    .order-lg-11 {
        order: 11; }
    .order-lg-12 {
        order: 12; }
    .offset-lg-0 {
        margin-left: 0; }
    .offset-lg-1 {
        margin-left: 8.33333%; }
    .offset-lg-2 {
        margin-left: 16.66667%; }
    .offset-lg-3 {
        margin-left: 25%; }
    .offset-lg-4 {
        margin-left: 33.33333%; }
    .offset-lg-5 {
        margin-left: 41.66667%; }
    .offset-lg-6 {
        margin-left: 50%; }
    .offset-lg-7 {
        margin-left: 58.33333%; }
    .offset-lg-8 {
        margin-left: 66.66667%; }
    .offset-lg-9 {
        margin-left: 75%; }
    .offset-lg-10 {
        margin-left: 83.33333%; }
    .offset-lg-11 {
        margin-left: 91.66667%; } }

@media (min-width: 1280px) {
    .nk-col-xl {
        flex-basis: 0;
        flex-grow: 1;
        max-width: 100%; }
    .nk-col-xl-auto {
        flex: 0 0 auto;
        width: auto;
        max-width: 100%; }
    .nk-col-xl-1 {
        flex: 0 0 8.33333%;
        max-width: 8.33333%; }
    .nk-col-xl-2 {
        flex: 0 0 16.66667%;
        max-width: 16.66667%; }
    .nk-col-xl-3 {
        flex: 0 0 25%;
        max-width: 25%; }
    .nk-col-xl-4 {
        flex: 0 0 33.33333%;
        max-width: 33.33333%; }
    .nk-col-xl-5 {
        flex: 0 0 41.66667%;
        max-width: 41.66667%; }
    .nk-col-xl-6 {
        flex: 0 0 50%;
        max-width: 50%; }
    .nk-col-xl-7 {
        flex: 0 0 58.33333%;
        max-width: 58.33333%; }
    .nk-col-xl-8 {
        flex: 0 0 66.66667%;
        max-width: 66.66667%; }
    .nk-col-xl-9 {
        flex: 0 0 75%;
        max-width: 75%; }
    .nk-col-xl-10 {
        flex: 0 0 83.33333%;
        max-width: 83.33333%; }
    .nk-col-xl-11 {
        flex: 0 0 91.66667%;
        max-width: 91.66667%; }
    .nk-col-xl-12 {
        flex: 0 0 100%;
        max-width: 100%; }
    .order-xl-first {
        order: -1; }
    .order-xl-last {
        order: 13; }
    .order-xl-0 {
        order: 0; }
    .order-xl-1 {
        order: 1; }
    .order-xl-2 {
        order: 2; }
    .order-xl-3 {
        order: 3; }
    .order-xl-4 {
        order: 4; }
    .order-xl-5 {
        order: 5; }
    .order-xl-6 {
        order: 6; }
    .order-xl-7 {
        order: 7; }
    .order-xl-8 {
        order: 8; }
    .order-xl-9 {
        order: 9; }
    .order-xl-10 {
        order: 10; }
    .order-xl-11 {
        order: 11; }
    .order-xl-12 {
        order: 12; }
    .offset-xl-0 {
        margin-left: 0; }
    .offset-xl-1 {
        margin-left: 8.33333%; }
    .offset-xl-2 {
        margin-left: 16.66667%; }
    .offset-xl-3 {
        margin-left: 25%; }
    .offset-xl-4 {
        margin-left: 33.33333%; }
    .offset-xl-5 {
        margin-left: 41.66667%; }
    .offset-xl-6 {
        margin-left: 50%; }
    .offset-xl-7 {
        margin-left: 58.33333%; }
    .offset-xl-8 {
        margin-left: 66.66667%; }
    .offset-xl-9 {
        margin-left: 75%; }
    .offset-xl-10 {
        margin-left: 83.33333%; }
    .offset-xl-11 {
        margin-left: 91.66667%; } }

.nk-icon {
    height: 1.5rem;
    width: 1.5rem;
    vertical-align: middle; }
.nk-icon--size-xs {
    height: 0.75rem;
    width: 0.75rem; }
.nk-icon--size-sm {
    height: 1rem;
    width: 1rem; }
.nk-icon--size-lg {
    height: 2.25rem;
    width: 2.25rem; }
.nk-icon--size-xl {
    height: 3rem;
    width: 3rem; }
.nk-icon--size-xxl {
    height: 6rem;
    width: 6rem; }
.nk-icon--color-nutmeg-green {
    fill: #2fb153; }
.nk-icon--color-nutmeg-green [stroke] {
    stroke: #2fb153; }
.nk-icon--color-emerald {
    fill: #2cd664; }
.nk-icon--color-emerald [stroke] {
    stroke: #2cd664; }
.nk-icon--color-sea-green {
    fill: #217b3e; }
.nk-icon--color-sea-green [stroke] {
    stroke: #217b3e; }
.nk-icon--color-killarney {
    fill: #365e42; }
.nk-icon--color-killarney [stroke] {
    stroke: #365e42; }
.nk-icon--color-bigstone {
    fill: #162b3b; }
.nk-icon--color-bigstone [stroke] {
    stroke: #162b3b; }
.nk-icon--color-matisse {
    fill: #1a6ca3; }
.nk-icon--color-matisse [stroke] {
    stroke: #1a6ca3; }
.nk-icon--color-dodger {
    fill: #2196f3; }
.nk-icon--color-dodger [stroke] {
    stroke: #2196f3; }
.nk-icon--color-cod {
    fill: #1c1c1c; }
.nk-icon--color-cod [stroke] {
    stroke: #1c1c1c; }
.nk-icon--color-mineshaft {
    fill: #424242; }
.nk-icon--color-mineshaft [stroke] {
    stroke: #424242; }
.nk-icon--color-boulder {
    fill: #7c7c7c; }
.nk-icon--color-boulder [stroke] {
    stroke: #7c7c7c; }
.nk-icon--color-chalice {
    fill: #adadad; }
.nk-icon--color-chalice [stroke] {
    stroke: #adadad; }
.nk-icon--color-haze {
    fill: #d8d8d8; }
.nk-icon--color-haze [stroke] {
    stroke: #d8d8d8; }
.nk-icon--color-wildsand {
    fill: #f7f7f7; }
.nk-icon--color-wildsand [stroke] {
    stroke: #f7f7f7; }
.nk-icon--color-lightning {
    fill: #fcb321; }
.nk-icon--color-lightning [stroke] {
    stroke: #fcb321; }
.nk-icon--color-pirate-gold {
    fill: #bf8003; }
.nk-icon--color-pirate-gold [stroke] {
    stroke: #bf8003; }
.nk-icon--color-pomegranate {
    fill: #f44336; }
.nk-icon--color-pomegranate [stroke] {
    stroke: #f44336; }
.nk-icon--color-poppy {
    fill: #b63228; }
.nk-icon--color-poppy [stroke] {
    stroke: #b63228; }
.nk-icon--color-crimson {
    fill: #e91e63; }
.nk-icon--color-crimson [stroke] {
    stroke: #e91e63; }
.nk-icon--color-seance {
    fill: #9c27b0; }
.nk-icon--color-seance [stroke] {
    stroke: #9c27b0; }
.nk-icon--color-fuchsia {
    fill: #673ab7; }
.nk-icon--color-fuchsia [stroke] {
    stroke: #673ab7; }
.nk-icon--color-indigo {
    fill: #3f51b5; }
.nk-icon--color-indigo [stroke] {
    stroke: #3f51b5; }
.nk-icon--color-white {
    fill: white; }
.nk-icon--color-white [stroke] {
    stroke: white; }
.nk-icon--color-black {
    fill: black; }
.nk-icon--color-black [stroke] {
    stroke: black; }
.nk-icon--color-default {
    fill: currentColor; }

.nk-logo {
    height: 1.5rem;
    width: 6rem; }
.nk-logo--organization.nk-logo {
    height: 1.5rem;
    width: 6rem; }
.nk-logo--organization--size-sm.nk-logo {
    height: 1rem;
    width: 4rem; }

.nk-heading--underline {
    border-bottom: 1px solid #d8d8d8;
    padding-bottom: 0.5rem; }

.nk-heading__icon {
    margin-right: 0.5rem; }

.nk-heading__children {
    vertical-align: middle; }

.nk-text {
    letter-spacing: -0.01em; }
.nk-text--style-jumbo {
    font-size: 2.75rem;
    line-height: 1.2;
    font-weight: 700;
    margin-bottom: 1.5rem; }
.nk-text--style-highlight {
    font-size: 2.25rem;
    line-height: 1.2;
    font-weight: 700;
    margin-bottom: 1.5rem; }
.nk-text--style-title-1 {
    font-size: 1.5rem;
    line-height: 1.4;
    font-weight: 700;
    margin-bottom: 1.5rem; }
.nk-text--style-title-2 {
    font-size: 1.25rem;
    line-height: 1.4;
    font-weight: 700;
    margin-bottom: 1rem; }
.nk-text--style-title-3 {
    font-size: 1rem;
    line-height: 1.625;
    font-weight: 700;
    margin-bottom: 1rem; }
.nk-text--style-text-1 {
    font-size: 1rem;
    line-height: 1.625;
    font-weight: 400;
    margin-bottom: 1rem; }
.nk-text--style-text-2 {
    font-size: 0.75rem;
    line-height: 1.625;
    font-weight: 400;
    margin-bottom: 1rem; }
.nk-text--tag-small {
    font-size: 0.75rem;
    line-height: 1.625;
    font-weight: 400;
    margin-bottom: 1rem; }
.nk-text--tag-span {
    margin-bottom: 0; }
.nk-text--size-xxl {
    font-size: 2.75rem; }
.nk-text--size-xl {
    font-size: 2.25rem; }
.nk-text--size-lg {
    font-size: 1.5rem; }
.nk-text--size-md {
    font-size: 1.25rem; }
.nk-text--size-sm {
    font-size: 1rem; }
.nk-text--size-xs {
    font-size: 0.75rem; }
@media (min-width: 0) {
    .nk-text {
        /* stylelint-disable-line at-rule-name-space-after */ }
    .nk-text--breakpoint-xs--fs-xs {
        font-weight: 0.75rem; }
    .nk-text--breakpoint-xs--fs-sm {
        font-weight: 1rem; }
    .nk-text--breakpoint-xs--fs-md {
        font-weight: 1.25rem; }
    .nk-text--breakpoint-xs--fs-lg {
        font-weight: 1.5rem; }
    .nk-text--breakpoint-xs--fs-xl {
        font-weight: 2.75rem; }
    .nk-text--breakpoint-xs--fs-xxl {
        font-weight: 2.75rem; }
    .nk-text--breakpoint-xs--fw-default {
        font-weight: 400; }
    .nk-text--breakpoint-xs--fw-medium {
        font-weight: 500; }
    .nk-text--breakpoint-xs--fw-bold {
        font-weight: 700; } }
@media (min-width: 524px) {
    .nk-text {
        /* stylelint-disable-line at-rule-name-space-after */ }
    .nk-text--breakpoint-sm--fs-xs {
        font-weight: 0.75rem; }
    .nk-text--breakpoint-sm--fs-sm {
        font-weight: 1rem; }
    .nk-text--breakpoint-sm--fs-md {
        font-weight: 1.25rem; }
    .nk-text--breakpoint-sm--fs-lg {
        font-weight: 1.5rem; }
    .nk-text--breakpoint-sm--fs-xl {
        font-weight: 2.75rem; }
    .nk-text--breakpoint-sm--fs-xxl {
        font-weight: 2.75rem; }
    .nk-text--breakpoint-sm--fw-default {
        font-weight: 400; }
    .nk-text--breakpoint-sm--fw-medium {
        font-weight: 500; }
    .nk-text--breakpoint-sm--fw-bold {
        font-weight: 700; } }
@media (min-width: 768px) {
    .nk-text {
        /* stylelint-disable-line at-rule-name-space-after */ }
    .nk-text--breakpoint-md--fs-xs {
        font-weight: 0.75rem; }
    .nk-text--breakpoint-md--fs-sm {
        font-weight: 1rem; }
    .nk-text--breakpoint-md--fs-md {
        font-weight: 1.25rem; }
    .nk-text--breakpoint-md--fs-lg {
        font-weight: 1.5rem; }
    .nk-text--breakpoint-md--fs-xl {
        font-weight: 2.75rem; }
    .nk-text--breakpoint-md--fs-xxl {
        font-weight: 2.75rem; }
    .nk-text--breakpoint-md--fw-default {
        font-weight: 400; }
    .nk-text--breakpoint-md--fw-medium {
        font-weight: 500; }
    .nk-text--breakpoint-md--fw-bold {
        font-weight: 700; } }
@media (min-width: 1024px) {
    .nk-text {
        /* stylelint-disable-line at-rule-name-space-after */ }
    .nk-text--breakpoint-lg--fs-xs {
        font-weight: 0.75rem; }
    .nk-text--breakpoint-lg--fs-sm {
        font-weight: 1rem; }
    .nk-text--breakpoint-lg--fs-md {
        font-weight: 1.25rem; }
    .nk-text--breakpoint-lg--fs-lg {
        font-weight: 1.5rem; }
    .nk-text--breakpoint-lg--fs-xl {
        font-weight: 2.75rem; }
    .nk-text--breakpoint-lg--fs-xxl {
        font-weight: 2.75rem; }
    .nk-text--breakpoint-lg--fw-default {
        font-weight: 400; }
    .nk-text--breakpoint-lg--fw-medium {
        font-weight: 500; }
    .nk-text--breakpoint-lg--fw-bold {
        font-weight: 700; } }
@media (min-width: 1280px) {
    .nk-text {
        /* stylelint-disable-line at-rule-name-space-after */ }
    .nk-text--breakpoint-xl--fs-xs {
        font-weight: 0.75rem; }
    .nk-text--breakpoint-xl--fs-sm {
        font-weight: 1rem; }
    .nk-text--breakpoint-xl--fs-md {
        font-weight: 1.25rem; }
    .nk-text--breakpoint-xl--fs-lg {
        font-weight: 1.5rem; }
    .nk-text--breakpoint-xl--fs-xl {
        font-weight: 2.75rem; }
    .nk-text--breakpoint-xl--fs-xxl {
        font-weight: 2.75rem; }
    .nk-text--breakpoint-xl--fw-default {
        font-weight: 400; }
    .nk-text--breakpoint-xl--fw-medium {
        font-weight: 500; }
    .nk-text--breakpoint-xl--fw-bold {
        font-weight: 700; } }
.nk-text--fw-default {
    font-weight: 400; }
.nk-text--fw-medium {
    font-weight: 500; }
.nk-text--fw-bold {
    font-weight: 700; }
.nk-text--align-left {
    text-align: left; }
.nk-text--align-center {
    text-align: center; }
.nk-text--align-right {
    text-align: right; }
.nk-text--color-default {
    color: #424242; }
.nk-text--color-brand {
    color: #2fb153; }
.nk-text--color-extra-light {
    color: #adadad; }
.nk-text--color-light {
    color: #7c7c7c; }
.nk-text--color-dark {
    color: #1c1c1c; }
.nk-text--color-link {
    color: #2196f3; }
.nk-text--no-stack {
    margin-bottom: 0; }

.nk-accordion__space--stretch--md {
    padding: 1rem 0.5rem; }

.nk-accordion__space--stretch--lg {
    padding: 1.5rem 1rem; }

.nk-accordion__space--inset--sm {
    padding: 0.5rem; }

.nk-accordion__space--inset--md {
    padding: 1rem; }

.nk-accordion__space--inset--lg {
    padding: 1.5rem; }

.nk-accordion__tab {
    background-color: #FFFFFF;
    border-bottom: 1px solid #d8d8d8; }
.nk-accordion__tab--no-last-border:last-of-type {
    border-bottom-width: 0; }

.nk-accordion__title {
    position: relative;
    display: flex;
    justify-content: space-between;
    justify-items: center;
    align-items: center;
    padding-right: 2rem;
    color: inherit; }
.nk-accordion__title > .nk-text {
    margin-bottom: 0; }
.nk-accordion__title > .nk-icon {
    position: absolute;
    right: 1rem;
    top: 0;
    bottom: 0;
    margin: auto 0; }
.nk-accordion__title--collapsed > .nk-icon {
    -webkit-transform: rotate(0deg);
    transform: rotate(0deg);
    -webkit-transition: all 50ms ease-in-out;
    transition: all 50ms ease-in-out; }
.nk-accordion__title--expanded > .nk-icon {
    -webkit-transform: rotate(90deg);
    transform: rotate(90deg);
    -webkit-transition: all 50ms ease-in-out;
    transition: all 50ms ease-in-out; }
.nk-accordion__title--no-padding {
    padding: 0; }

.nk-accordion__body {
    overflow: hidden; }
.nk-accordion__body--collapsed {
    max-height: 0;
    -webkit-transition: max-height 200ms cubic-bezier(0, 1, 0, 1);
    transition: max-height 200ms cubic-bezier(0, 1, 0, 1); }
.nk-accordion__body--expanded {
    max-height: 5000px;
    -webkit-transition: max-height 600ms ease-in-out;
    transition: max-height 600ms ease-in-out; }

.nk-accordion__body-inner:not(.nk-accordion__body-inner--no-padding) {
    padding-top: 0; }

.nk-accordion__body-inner--no-padding {
    padding-bottom: 0;
    padding-left: 0;
    padding-right: 0; }

.nk-panel {
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    display: block;
    background-color: white;
    border: solid 1px #d8d8d8;
    border-radius: 2px;
    margin-top: 0.5rem;
    margin-bottom: 0.5rem; }
.nk-panel__body > *:last-child {
    margin-bottom: 0; }
.nk-panel__title {
    display: flex;
    justify-content: space-between;
    justify-items: center;
    align-items: center; }
.nk-panel__space--stretch--md .nk-panel__body,
.nk-panel__space--stretch--md .nk-panel__title {
    padding: 1rem 0.5rem; }
.nk-panel__space--stretch--lg .nk-panel__body,
.nk-panel__space--stretch--lg .nk-panel__title {
    padding: 1.5rem 1rem; }
.nk-panel__space--inset--sm .nk-panel__body,
.nk-panel__space--inset--sm .nk-panel__title {
    padding: 0.5rem; }
.nk-panel__space--inset--md .nk-panel__body,
.nk-panel__space--inset--md .nk-panel__title {
    padding: 1rem; }
.nk-panel__space--inset--lg .nk-panel__body,
.nk-panel__space--inset--lg .nk-panel__title {
    padding: 1.5rem; }
.nk-panel__title + .nk-panel__body {
    padding-top: 0; }
.nk-panel--is-full-width {
    margin: 0;
    border-radius: 0; }
.nk-panel__title > .nk-text {
    margin-bottom: 0; }

@-webkit-keyframes nkLoadingRotate {
    0% {
        -webkit-transform: rotate(0deg) translateZ(0);
        transform: rotate(0deg) translateZ(0); }
    100% {
        -webkit-transform: rotate(360deg) translateZ(0);
        transform: rotate(360deg) translateZ(0); } }

@keyframes nkLoadingRotate {
    0% {
        -webkit-transform: rotate(0deg) translateZ(0);
        transform: rotate(0deg) translateZ(0); }
    100% {
        -webkit-transform: rotate(360deg) translateZ(0);
        transform: rotate(360deg) translateZ(0); } }

.nk-loading {
    display: flex;
    justify-content: center;
    padding: 1.5rem; }
.nk-loading::before {
    display: block;
    content: '';
    width: 1.5rem;
    height: 1.5rem;
    border-radius: 50%;
    border: 2px solid #2fb153;
    border-left-color: transparent;
    -webkit-transform: translateZ(0);
    transform: translateZ(0);
    -webkit-animation: nkLoadingRotate 1s infinite linear;
    animation: nkLoadingRotate 1s infinite linear; }
.nk-loading--small::before {
    width: 0.75rem;
    height: 0.75rem;
    border-width: 1.5px; }
.nk-loading--in-primary-button, .nk-loading--in-secondary-button {
    position: absolute;
    padding: 0;
    top: 0;
    bottom: 0;
    right: 0;
    left: 0; }
.nk-loading--in-primary-button::before, .nk-loading--in-secondary-button::before {
    margin: auto 0; }
.nk-loading--in-primary-button::before {
    border-color: white;
    border-left-color: transparent; }
.nk-loading--in-secondary-button::before {
    border-color: #217b3e;
    border-left-color: transparent;
    opacity: 0.4; }
.nk-loading--overlay {
    position: fixed;
    top: 0;
    bottom: 0;
    right: 0;
    left: 0;
    z-index: 1100;
    display: flex;
    align-items: center;
    background-color: rgba(216, 216, 216, 0.75); }
.nk-loading--no-padding {
    padding: 0; }
.nk-loading--inline {
    padding: 0;
    display: inline; }
.nk-loading--inline::before {
    display: inline-flex;
    padding: 0;
    vertical-align: middle; }
.nk-loading--inline-padding--left {
    padding-left: 1rem; }
.nk-loading--inline-padding--right {
    padding-right: 1rem; }

.nk-button {
    border-radius: 2px;
    position: relative;
    -webkit-transition: 200ms box-shadow ease-in;
    transition: 200ms box-shadow ease-in;
    background-color: transparent;
    background-image: none;
    display: inline-block;
    border-radius: 2px;
    border: none;
    cursor: pointer;
    text-align: center;
    white-space: nowrap;
    min-width: 3rem;
    text-decoration: none;
    font-weight: 400;
    font-size: 1rem;
    letter-spacing: -0.01em;
    padding: 1rem 2rem;
    -webkit-transition-duration: 200ms;
    transition-duration: 200ms;
    -webkit-transition-timing-function: ease;
    transition-timing-function: ease;
    -webkit-transition-property: background-color;
    transition-property: background-color;
    box-sizing: content-box;
    line-height: 1; }
.nk-button:focus {
    outline: none;
    box-shadow: 0 0 0 0.25rem rgba(33, 150, 243, 0.2); }
.nk-button:hover {
    text-decoration: none; }
.nk-button--sm {
    font-size: 0.75rem;
    min-width: 2rem;
    padding: 0.5rem 1.5rem; }
.nk-button--primary {
    color: white;
    background-color: #2fb153;
    text-shadow: 0.02em 0.02em 0.02em rgba(0, 0, 0, 0.2); }
.nk-button--primary:hover {
    color: white;
    background-color: #217b3e; }
.nk-button--primary.nk-button--is-disabled, .nk-button--primary.nk-button:disabled {
    opacity: 0.6; }
.nk-button--secondary {
    color: #217b3e;
    box-shadow: inset 0 0 0 1px #217b3e;
    -webkit-transition-property: background-color;
    transition-property: background-color; }
.nk-button--secondary:hover {
    color: #217b3e;
    background-color: rgba(47, 177, 83, 0.1); }
.nk-button--secondary.nk-button--is-disabled .nk-button__children, .nk-button--secondary.nk-button:disabled .nk-button__children {
    opacity: 0.4; }
.nk-button--link {
    text-align: left;
    line-height: inherit;
    color: #2196f3;
    padding: 0;
    min-width: auto;
    font-size: inherit; }
.nk-button--link:hover {
    color: #1a6ca3; }
.nk-button--link.nk-button--sm {
    font-size: 0.75rem; }
.nk-button--is-disabled, .nk-button:disabled {
    cursor: not-allowed;
    pointer-events: none;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none; }
.nk-button--no-padding {
    padding: 0; }
.nk-button--block {
    width: 100%;
    max-width: 100%;
    display: block; }
.nk-button--is-loading {
    position: relative; }
.nk-button--is-loading .nk-button__children {
    visibility: hidden; }

/**
 * Apply Mobile First & Group selectors:
 *
 * e.g.
 *
 * .my-icon-example {
 *   width: 12px;
 *   @include nk-small-tablet {
 *     width: 14px;
 *   }
 *   @include nk-tablet {
 *     width: 16px;
 *   }
 *   @include nk-desktop {
 *     width: 18px;
 *   }
 *   @include nk-desktop-large {
 *     width: 20px;
 *   }
 * }
 *
 */
.nk-button-group {
    display: flex;
    margin-bottom: 1rem;
    margin-left: -0.5rem;
    margin-right: -0.5rem; }
.nk-button-group .nk-button,
.nk-button-group .nk-link--button {
    margin: 0 0.5rem; }
.nk-button-group--center {
    justify-content: center; }
.nk-button-group--justify {
    justify-content: space-between; }
.nk-button-group--left {
    justify-content: flex-start; }
.nk-button-group--right {
    justify-content: flex-end; }
.nk-button-group--stack-up {
    margin-top: 2rem; }
@media (max-width: 523px) {
    .nk-button-group > .nk-button,
    .nk-button-group .nk-link--button {
        width: 100%; }
    .nk-button-group--stack-on-mobile.nk-button-group {
        flex-direction: column-reverse; }
    .nk-button-group--stack-on-mobile.nk-button-group .nk-button,
    .nk-button-group--stack-on-mobile.nk-button-group .nk-link--button {
        width: auto; }
    .nk-button-group--stack-on-mobile.nk-button-group .nk-button:not(:first-child),
    .nk-button-group--stack-on-mobile.nk-button-group .nk-link--button:not(:first-child) {
        margin-bottom: 1rem; } }

.nk-link {
    color: #2196f3; }
.nk-link--sm {
    font-size: 0.75rem; }
.nk-link:hover {
    color: #1a6ca3; }
.nk-link--button {
    border-radius: 2px;
    position: relative;
    -webkit-transition: 200ms box-shadow ease-in;
    transition: 200ms box-shadow ease-in;
    background-color: transparent;
    background-image: none;
    display: inline-block;
    border-radius: 2px;
    border: none;
    cursor: pointer;
    text-align: center;
    white-space: nowrap;
    min-width: 3rem;
    text-decoration: none;
    font-weight: 400;
    font-size: 1rem;
    letter-spacing: -0.01em;
    padding: 1rem 2rem;
    -webkit-transition-duration: 200ms;
    transition-duration: 200ms;
    -webkit-transition-timing-function: ease;
    transition-timing-function: ease;
    -webkit-transition-property: background-color;
    transition-property: background-color;
    box-sizing: content-box;
    line-height: 1; }
.nk-link--button:focus {
    outline: none;
    box-shadow: 0 0 0 0.25rem rgba(33, 150, 243, 0.2); }
.nk-link--button:hover {
    text-decoration: none; }
.nk-link--button--sm {
    font-size: 0.75rem;
    min-width: 2rem;
    padding: 0.5rem 1.5rem; }
.nk-link--button--primary {
    color: white;
    background-color: #2fb153;
    text-shadow: 0.02em 0.02em 0.02em rgba(0, 0, 0, 0.2); }
.nk-link--button--primary:hover {
    color: white;
    background-color: #217b3e; }
.nk-link--button--primary.nk-link--button--is-disabled, .nk-link--button--primary.nk-link--button:disabled {
    opacity: 0.6; }
.nk-link--button--secondary {
    color: #217b3e;
    box-shadow: inset 0 0 0 1px #217b3e;
    -webkit-transition-property: background-color;
    transition-property: background-color; }
.nk-link--button--secondary:hover {
    color: #217b3e;
    background-color: rgba(47, 177, 83, 0.1); }
.nk-link--button--secondary.nk-link--button--is-disabled .nk-link--button__children, .nk-link--button--secondary.nk-link--button:disabled .nk-link--button__children {
    opacity: 0.4; }
.nk-link--button--link {
    text-align: left;
    line-height: inherit;
    color: #2196f3;
    padding: 0;
    min-width: auto;
    font-size: inherit; }
.nk-link--button--link:hover {
    color: #1a6ca3; }
.nk-link--button--link.nk-link--button--sm {
    font-size: 0.75rem; }
.nk-link--button--is-disabled, .nk-link--button:disabled {
    cursor: not-allowed;
    pointer-events: none;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none; }
.nk-link--button--no-padding {
    padding: 0; }
.nk-link--button--block {
    width: 100%;
    max-width: 100%;
    display: block; }
.nk-link--button--is-loading {
    position: relative; }
.nk-link--button--is-loading .nk-link--button__children {
    visibility: hidden; }
.nk-link--button--sm {
    font-size: 0.75rem; }

/**
 * Apply Mobile First & Group selectors:
 *
 * e.g.
 *
 * .my-icon-example {
 *   width: 12px;
 *   @include nk-small-tablet {
 *     width: 14px;
 *   }
 *   @include nk-tablet {
 *     width: 16px;
 *   }
 *   @include nk-desktop {
 *     width: 18px;
 *   }
 *   @include nk-desktop-large {
 *     width: 20px;
 *   }
 * }
 *
 */
/**
 * Apply Mobile First & Group selectors:
 *
 * e.g.
 *
 * .my-icon-example {
 *   width: 12px;
 *   @include nk-small-tablet {
 *     width: 14px;
 *   }
 *   @include nk-tablet {
 *     width: 16px;
 *   }
 *   @include nk-desktop {
 *     width: 18px;
 *   }
 *   @include nk-desktop-large {
 *     width: 20px;
 *   }
 * }
 *
 */
.nk-header {
    align-items: center;
    background-color: white;
    border-bottom: 1px solid #d8d8d8;
    color: #424242;
    display: flex;
    height: 3.125rem;
    position: relative;
    width: 100%;
    padding-top: 0.25rem;
    margin-bottom: 1.5rem; }
.nk-header::before {
    background-color: #2fb153;
    content: '';
    position: absolute;
    height: 0.25rem;
    top: 0;
    width: 100%; }
.nk-header__container {
    align-items: center;
    display: flex; }
.nk-header--fixed {
    height: 3.125rem;
    margin-bottom: 1.5rem; }
.nk-header--fixed .nk-header {
    position: fixed;
    z-index: 950; }
.nk-header--page {
    color: #424242; }
.nk-header--page .nk-header__title {
    margin: 0 auto;
    overflow: hidden;
    text-align: center;
    text-overflow: ellipsis;
    white-space: nowrap; }
.nk-header--page .nk-header__center-item {
    margin: 0 auto;
    text-align: center; }
.nk-header--page .nk-header__left-item,
.nk-header--page .nk-header__right-item {
    align-items: center;
    display: flex;
    flex-direction: row;
    flex-wrap: nowrap;
    min-width: 10%;
    white-space: nowrap; }
.nk-header--page .nk-header__left-item .nk-icon,
.nk-header--page .nk-header__right-item .nk-icon {
    fill: #424242; }
.nk-header--page .nk-header__left-item span,
.nk-header--page .nk-header__right-item span {
    color: #424242;
    vertical-align: middle; }
.nk-header--page .nk-header__left-item {
    margin-right: 1rem;
    justify-content: flex-start; }
.nk-header--page .nk-header__right-item {
    margin-left: 1rem;
    justify-content: flex-end; }
.nk-header--no-stack {
    margin-bottom: 0; }

.nk-button-with-icon svg {
    position: absolute; }

.nk-button-with-icon--primary-dark {
    background-color: #424242; }
.nk-button-with-icon--primary-dark:hover, .nk-button-with-icon--primary-dark:active {
    background-color: #7c7c7c; }

.nk-button-with-icon--link-dark.nk-button {
    color: #424242; }
.nk-button-with-icon--link-dark.nk-button:hover, .nk-button-with-icon--link-dark.nk-button:active {
    color: #7c7c7c; }

.nk-button-with-icon__icon-left svg {
    left: 1.5rem; }

.nk-button-with-icon__icon-left .nk-button-with-icon__label {
    padding-left: 1.5rem; }

.nk-button-with-icon__icon-right svg {
    right: 1.5rem; }

.nk-button-with-icon__icon-right .nk-button-with-icon__label {
    padding-right: 1.5rem; }

.nk-button-with-icon--sm svg {
    top: 0.35rem; }

.nk-button-with-icon--md svg {
    top: 0.7rem; }

.nk-button-with-icon--link svg {
    position: static; }

.nk-button-with-icon--link .nk-button-with-icon__label {
    padding-right: 0.25rem;
    padding-left: 0.25rem; }

/* Checks for a valid CSS length.
 *
 * @argument {string} $value
 *
 * @return {boolean}
 *
 * @access private
 */
/* Transforms shorthand that can range from 1-to-4 values to be 4 values.
 *
 * @argument {list} $shorthand
 *
 * @example scss
 *   .element {
 *     margin: _unpack(1em 2em);
 *   }
 *
 *   // CSS Output
 *   .element {
 *     margin: 1em 2em 1em 2em;
 *   }
 *
 * @access private
 */
/**
 * @example scss
 *   .element {
 *     @include position(relative, 0 null null 10em);
 *   }
 *
 *   // CSS Output
 *   .element {
 *     left: 10em;
 *     position: relative;
 *     top: 0;
 *   }
 *
 * @example scss
 *   .element {
 *     @include position(absolute, 0);
 *   }
 *
 *   // CSS Output
 *   .element {
 *     position: absolute;
 *     top: 0;
 *     right: 0;
 *     bottom: 0;
 *     left: 0;
 *   }
 */
.nk-accessibility__group {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0; }

.nk-accessibility--splash {
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    display: block;
    border-radius: 50%;
    background-color: #2196f3;
    pointer-events: none;
    margin: auto;
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    -webkit-animation: nutkit-focus-splash 600ms cubic-bezier(0.4, 0, 0.2, 1);
    animation: nutkit-focus-splash 600ms cubic-bezier(0.4, 0, 0.2, 1);
    -webkit-animation-fill-mode: forwards;
    animation-fill-mode: forwards; }

.nk-accessibility--focus, .nk-accessibility--hover, .nk-accessibility--active {
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    display: block;
    border-radius: 50%;
    background-color: #2196f3;
    pointer-events: none;
    margin: auto;
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    -webkit-animation: nutkit-focus-key 200ms cubic-bezier(0.4, 0, 0.2, 1);
    animation: nutkit-focus-key 200ms cubic-bezier(0.4, 0, 0.2, 1);
    -webkit-animation-fill-mode: forwards;
    animation-fill-mode: forwards; }

@-webkit-keyframes nutkit-focus-splash {
    0% {
        opacity: 0.4;
        -webkit-transform: scale(0);
        transform: scale(0); }
    100% {
        opacity: 0;
        -webkit-transform: scale(2.6);
        transform: scale(2.6); } }

@keyframes nutkit-focus-splash {
    0% {
        opacity: 0.4;
        -webkit-transform: scale(0);
        transform: scale(0); }
    100% {
        opacity: 0;
        -webkit-transform: scale(2.6);
        transform: scale(2.6); } }

@-webkit-keyframes nutkit-focus-key {
    0% {
        opacity: 0.1;
        -webkit-transform: scale(0.4);
        transform: scale(0.4); }
    100% {
        opacity: 0.2;
        -webkit-transform: scale(2);
        transform: scale(2); } }

@keyframes nutkit-focus-key {
    0% {
        opacity: 0.1;
        -webkit-transform: scale(0.4);
        transform: scale(0.4); }
    100% {
        opacity: 0.2;
        -webkit-transform: scale(2);
        transform: scale(2); } }

.nk-radio-group {
    width: 100%;
    margin-bottom: 1.5rem; }
.nk-radio-group > li {
    list-style-type: none;
    position: relative; }
.nk-radio-group__list-style--underline > li {
    border-bottom: 1px solid #d8d8d8; }
.nk-radio-group__list-style--box > li {
    border: 1px solid #d8d8d8;
    margin-bottom: 1rem; }
.nk-radio-group__space--inset--sm .nk-radio-input__label {
    padding: 0.5rem 2.5rem 0.5rem 0.5rem; }
.nk-radio-group__space--inset--sm .nk-radio-input__visual {
    right: 0.5rem;
    top: 0.5rem; }
.nk-radio-group__space--inset--md .nk-radio-input__label {
    padding: 1rem 2.5rem 1rem 1rem; }
.nk-radio-group__space--inset--md .nk-radio-input__label > *:first-child {
    display: block;
    padding-right: 1rem; }
.nk-radio-group__space--inset--md .nk-radio-input__visual {
    right: 1rem;
    top: 1rem; }

.nk-radio-input {
    position: relative;
    width: 100%;
    -webkit-transition: ease 200ms background-color;
    transition: ease 200ms background-color; }
.nk-radio-input__list-item {
    list-style: none; }
.nk-radio-input:hover {
    background-color: #f7f7f7; }
.nk-radio-input__visual {
    position: absolute;
    right: 1rem;
    top: 1rem; }
.nk-radio-input__body > *:last-child {
    margin-bottom: 0; }
.nk-radio-input__icon.nk-icon {
    display: block;
    border-radius: 1.5rem;
    height: 1.5rem;
    pointer-events: none;
    width: 1.5rem; }
.nk-radio-input__icon.nk-icon #circle,
.nk-radio-input__icon.nk-icon #dot {
    -webkit-transition: ease 200ms fill;
    transition: ease 200ms fill; }
.nk-radio-input__icon.nk-icon #circle {
    fill: #7c7c7c; }
.nk-radio-input__icon.nk-icon #dot {
    fill: none;
    -webkit-transform: scale(0.5);
    transform: scale(0.5);
    -webkit-transform-origin: 50% 50%;
    transform-origin: 50% 50%;
    -webkit-transition: linear 66.66667ms transform;
    transition: linear 66.66667ms transform; }
.nk-radio-input__icon.nk-icon #tick {
    fill: none; }
.nk-radio-input__input {
    opacity: 0;
    width: 0;
    height: 0;
    position: absolute; }
.nk-radio-input--is-checked .nk-radio-input__icon #circle,
.nk-radio-input--is-checked .nk-radio-input__icon #dot {
    fill: #2196f3; }
.nk-radio-input--is-checked .nk-radio-input__icon #dot {
    -webkit-transform: scale(1);
    transform: scale(1); }
.nk-radio-input__label {
    cursor: pointer;
    display: block;
    padding: 1rem 2.5rem 1rem 1rem; }

@-webkit-keyframes closeNotification {
    0% {
        -webkit-transform: rotateX(0);
        transform: rotateX(0); }
    100% {
        -webkit-transform: rotateX(90deg);
        transform: rotateX(90deg); } }

@keyframes closeNotification {
    0% {
        -webkit-transform: rotateX(0);
        transform: rotateX(0); }
    100% {
        -webkit-transform: rotateX(90deg);
        transform: rotateX(90deg); } }

@-webkit-keyframes fadeIn {
    0% {
        opacity: 0;
        -webkit-transform: scale(0.9);
        transform: scale(0.9); }
    100% {
        opacity: 1;
        -webkit-transform: scale(1);
        transform: scale(1); } }

@keyframes fadeIn {
    0% {
        opacity: 0;
        -webkit-transform: scale(0.9);
        transform: scale(0.9); }
    100% {
        opacity: 1;
        -webkit-transform: scale(1);
        transform: scale(1); } }

.nk-notification {
    padding: 1rem;
    display: flex;
    flex-direction: row;
    flex-wrap: nowrap;
    margin-bottom: 1rem; }
.nk-notification--border {
    border-top: 2px solid transparent; }
.nk-notification--size-xs {
    padding: 0.5rem; }
.nk-notification__wrapper {
    -webkit-perspective-origin: top;
    perspective-origin: top; }
.nk-notification svg {
    display: block; }
.nk-notification__content {
    flex: 1 1 auto;
    padding-left: 1rem;
    word-break: break-word; }
.nk-notification--size-xs .nk-notification__content {
    padding-left: 0.5rem; }
.nk-notification__icon > .nk-icon {
    -webkit-animation: fadeIn 400ms cubic-bezier(0.4, 0, 0.2, 1);
    animation: fadeIn 400ms cubic-bezier(0.4, 0, 0.2, 1);
    -webkit-transform-origin: center;
    transform-origin: center; }
.nk-notification__dismiss {
    background-color: transparent;
    border: 0;
    padding: 0;
    cursor: pointer;
    flex: 0 0 1.5rem;
    height: 1.5rem;
    justify-content: center;
    align-items: center;
    display: flex;
    -webkit-transform: translateX(0.5rem);
    transform: translateX(0.5rem); }
.nk-notification--default {
    background-color: rgba(124, 124, 124, 0.1);
    border-top-color: #424242;
    color: #424242; }
.nk-notification--warning {
    background-color: rgba(252, 179, 33, 0.1);
    border-top-color: #bf8003;
    color: #424242; }
.nk-notification--error {
    background-color: rgba(182, 50, 40, 0.1);
    border-top-color: #b63228;
    color: #b63228; }
.nk-notification--information {
    background-color: rgba(26, 108, 163, 0.1);
    border-top-color: #1a6ca3;
    color: #1a6ca3; }
.nk-notification--success {
    background-color: rgba(44, 214, 100, 0.1);
    border-top-color: #217b3e;
    color: #217b3e; }
.nk-notification--no-stack {
    margin-bottom: 0; }

.nk-input {
    margin-bottom: 1.5rem; }
.nk-input--no-stack {
    margin-bottom: 0; }
.nk-input label {
    display: block;
    font-size: 0.75rem;
    font-weight: 500;
    color: #424242; }
.nk-input__element {
    display: flex;
    flex-direction: row;
    flex-wrap: nowrap;
    align-items: center; }
.nk-input__icon {
    margin-right: 0.25rem; }
.nk-input__text-prefix {
    color: #1c1c1c;
    padding: 0.25rem 0 0.25rem 0;
    margin-right: 0.25rem;
    line-height: 1.5;
    cursor: default; }
.nk-input__state {
    flex: 0 0 100%; }
.nk-input__state::after {
    position: absolute;
    content: '';
    width: 100%;
    height: 1px;
    background: #adadad;
    background-size: 200% 100%;
    background-position: right bottom;
    -webkit-transition: linear 200ms background;
    transition: linear 200ms background; }
.nk-input__state-icon {
    display: flex; }
.nk-input__element:focus-within ~ .nk-input__state::after {
    background: #2196f3; }
input:focus ~ .nk-input__state-icon {
    display: none; }
.nk-input__help {
    font-size: 0.75rem;
    color: #7c7c7c;
    padding: 0.5rem 0; }
.nk-input--valid .nk-input__state::after {
    background: #2fb153; }
.nk-input--error .nk-input__state::after {
    background: #f44336; }
.nk-input__edit-icon {
    cursor: pointer; }
.nk-input input {
    padding: 0.25rem 0 0.25rem 0;
    font-weight: 400;
    font-size: 1rem;
    color: #1c1c1c;
    line-height: 1.5;
    background-color: transparent;
    border: 0;
    flex-grow: 1; }
.nk-input input:focus {
    outline: none; }
.nk-input input:focus + .nk-input__state::after {
    background-position: left bottom; }
.nk-input input::-webkit-input-placeholder {
    color: #7c7c7c; }
.nk-input input::-moz-placeholder {
    color: #7c7c7c; }
.nk-input input:-ms-input-placeholder {
    color: #7c7c7c; }
.nk-input input::-ms-input-placeholder {
    color: #7c7c7c; }
.nk-input input::placeholder {
    color: #7c7c7c; }
.nk-input input:disabled {
    color: #7c7c7c;
    cursor: not-allowed; }
.nk-input input:disabled::-webkit-input-placeholder {
    color: #7c7c7c; }
.nk-input input:disabled::-moz-placeholder {
    color: #7c7c7c; }
.nk-input input:disabled:-ms-input-placeholder {
    color: #7c7c7c; }
.nk-input input:disabled::-ms-input-placeholder {
    color: #7c7c7c; }
.nk-input input:disabled::placeholder {
    color: #7c7c7c; }
.nk-input--disabled .nk-input__state::after {
    background: #d8d8d8; }
.nk-input--disabled label {
    font-weight: 400;
    color: #7c7c7c; }
.nk-input--disabled .nk-input__text-prefix {
    color: #7c7c7c; }
.nk-input > div {
    position: relative; }

.nk-amount {
    white-space: nowrap; }
.nk-amount--type-overall {
    color: #1a6ca3; }
.nk-amount--type-contribution {
    color: #424242; }
.nk-amount--positive.nk-amount--type-performance {
    color: #2fb153; }
.nk-amount--negative.nk-amount--type-overall {
    color: #424242; }
.nk-amount--no-color.nk-amount {
    color: inherit; }
.nk-amount--size-xs {
    font-size: 0.75rem; }
.nk-amount--size-sm {
    font-size: 1rem; }
.nk-amount--size-md {
    font-size: 1.25rem; }
.nk-amount--size-lg {
    font-size: 1.5rem; }
.nk-amount--size-xl {
    font-size: 2.25rem; }
.nk-amount--size-xxl {
    font-size: 2.75rem; }

.nk-slider__container {
    margin: 0 0 1rem 0; }

.nk-slider__labels {
    display: flex;
    justify-content: space-between; }

.nk-slider__labels-top {
    align-items: flex-end;
    margin: 0 0 0.5rem 0;
    height: 2rem; }

.nk-slider__label-text {
    padding: 0;
    border: none;
    background-color: transparent;
    text-align: left;
    text-align: initial;
    width: 100%; }
.nk-slider__label-text--is-editable {
    cursor: pointer; }
.nk-slider__label-text--is-not-editable {
    outline: 0; }
.nk-slider__label-text--align-right {
    text-align: right; }

.nk-slider__label-icon {
    margin: 0 0 0 0.1rem; }

.nk-slider__input {
    border: none;
    padding: 0;
    background-color: transparent;
    width: 100%;
    outline: 0;
    text-align: right;
    font-size: 1.5rem;
    line-height: 1.2; }

.nk-slider__input--text-align-right {
    text-align: right; }

.nk-slider__input--text-align-left {
    text-align: left; }

.nk-slider__base {
    height: 2.25rem;
    display: flex;
    align-items: center;
    cursor: pointer; }
.nk-slider__base__input {
    position: relative;
    background-color: #d8d8d8;
    height: 0.375rem;
    border-radius: 1rem;
    width: 100%; }
.nk-slider__base__handle {
    position: absolute;
    cursor: pointer;
    touch-action: none;
    top: -0.375rem;
    margin: 0 0 0 -0.56rem;
    height: 1.125rem;
    width: 1.125rem;
    border-radius: 100%;
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1), 0 3px 6px rgba(0, 0, 0, 0.1);
    outline: 0;
    border: none; }
.nk-slider__base__handle::after {
    content: '';
    background-color: white;
    height: 0.5rem;
    width: 0.5rem;
    position: absolute;
    top: 0;
    bottom: 0;
    right: 0;
    left: 0;
    margin: auto;
    border-radius: 100%; }
.nk-slider__base__track {
    position: absolute;
    height: 100%;
    border-radius: 1rem; }
.nk-slider__base--is-disabled .nk-slider__base__input {
    cursor: default; }
.nk-slider__base--color-primary .nk-slider__base__track,
.nk-slider__base--color-primary .nk-slider__base__handle {
    background-color: #2fb153; }
.nk-slider__base--color-secondary .nk-slider__base__track,
.nk-slider__base--color-secondary .nk-slider__base__handle {
    background-color: #2196f3; }

.nk-slider__error {
    margin-top: 1rem; }

.nk-box {
    display: block;
    margin-bottom: 1rem;
    background-color: #f7f7f7; }
.nk-box__stripe {
    border-left: 0.25rem solid; }
.nk-box__stripe--color-product-primary {
    border-left-color: #2cd664; }
.nk-box__stripe--color-product-secondary {
    border-left-color: #3f51b5; }
.nk-box__stripe--color-intensity-one {
    border-left-color: #a7d6ed;
    background-color: rgba(167, 214, 237, 0.2); }
.nk-box__stripe--color-intensity-two {
    border-left-color: #68bed6;
    background-color: rgba(104, 190, 214, 0.2); }
.nk-box__stripe--color-intensity-three {
    border-left-color: #41acc8;
    background-color: rgba(65, 172, 200, 0.2); }
.nk-box__stripe--color-intensity-four {
    border-left-color: #009ab9;
    background-color: rgba(0, 154, 185, 0.2); }
.nk-box__stripe--color-intensity-five {
    border-left-color: #0089a9;
    background-color: rgba(0, 137, 169, 0.2); }
.nk-box__stripe--color-intensity-six {
    border-left-color: #00799a;
    background-color: rgba(0, 121, 154, 0.2); }
.nk-box__stripe--color-intensity-seven {
    border-left-color: #586685;
    background-color: rgba(88, 102, 133, 0.2); }
.nk-box__stripe--color-intensity-eight {
    border-left-color: #8a5775;
    background-color: rgba(138, 87, 117, 0.2); }
.nk-box__stripe--color-intensity-nine {
    border-left-color: #b94762;
    background-color: rgba(185, 71, 98, 0.2); }
.nk-box__stripe--color-intensity-ten {
    border-left-color: #e6304a;
    background-color: rgba(230, 48, 74, 0.2); }
.nk-box--no-stack {
    margin-bottom: 0; }
.nk-box__space--inset--sm {
    padding: 0.5rem 1rem; }
.nk-box__space--inset--md {
    padding: 1rem 1.5rem; }

.nk-box-with-outline {
    background-color: rgba(0, 0, 0, 0);
    border: 1px #424242 solid; }

/**
 * Apply Mobile First & Group selectors:
 *
 * e.g.
 *
 * .my-icon-example {
 *   width: 12px;
 *   @include nk-small-tablet {
 *     width: 14px;
 *   }
 *   @include nk-tablet {
 *     width: 16px;
 *   }
 *   @include nk-desktop {
 *     width: 18px;
 *   }
 *   @include nk-desktop-large {
 *     width: 20px;
 *   }
 * }
 *
 */
.modal-open {
    overflow: hidden; }
.modal-open .modal {
    overflow-x: hidden;
    overflow-y: auto; }

.nk-modal {
    bottom: 0;
    display: none;
    position: fixed;
    left: 0;
    margin: 0.5rem;
    overflow: hidden;
    outline: 0;
    right: 0;
    top: 0;
    z-index: 1100; }
.nk-modal__dialog {
    display: flex;
    align-items: top;
    justify-content: center;
    position: relative;
    pointer-events: none;
    width: auto; }
.nk-modal__content {
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    position: relative;
    width: 100%;
    pointer-events: auto;
    background-color: white;
    background-clip: padding-box;
    border-radius: 2px;
    outline: 0; }
.nk-modal__body {
    position: relative;
    padding: 1.5rem; }
.nk-modal__body > *:last-child {
    margin-bottom: 0; }
.nk-modal__close-button.nk-button {
    background-color: transparent;
    border: 0;
    cursor: pointer;
    position: absolute;
    right: 0.5rem;
    top: 0.5rem;
    z-index: 1100; }
.nk-modal__backdrop {
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    z-index: 1040;
    background-color: #424242;
    opacity: 0.5; }
@media (min-width: 524px) {
    .nk-modal__dialog {
        align-items: center;
        height: 100%; }
    .nk-modal__content {
        max-width: 32rem; } }

.RiskLevel__slider, .RiskLevel__overview, .RiskLevel__additional-info {
    margin: 0 0 2rem 0; }

/**
 * Apply Mobile First & Group selectors:
 *
 * e.g.
 *
 * .my-icon-example {
 *   width: 12px;
 *   @include nk-small-tablet {
 *     width: 14px;
 *   }
 *   @include nk-tablet {
 *     width: 16px;
 *   }
 *   @include nk-desktop {
 *     width: 18px;
 *   }
 *   @include nk-desktop-large {
 *     width: 20px;
 *   }
 * }
 *
 */
.nk-navigation {
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    display: flex;
    flex-wrap: nowrap;
    justify-content: flex-start;
    list-style: none;
    margin-bottom: 1rem;
    width: 100%; }
.nk-navigation-item {
    background-color: white;
    cursor: pointer;
    flex-grow: 1;
    flex-shrink: 0;
    flex-basis: calc(100% / 3);
    flex-wrap: nowrap;
    text-align: center;
    white-space: nowrap; }
@media (min-width: 768px) {
    .nk-navigation-item {
        flex: 1 0; } }
.nk-navigation-item + .nk-navigation-item {
    margin-left: 2px; }
.nk-navigation-item__link {
    border-radius: 2px;
    position: relative;
    -webkit-transition: 200ms box-shadow ease-in;
    transition: 200ms box-shadow ease-in;
    color: inherit;
    display: block;
    padding: 0.5rem;
    text-decoration: none;
    -webkit-transition: box-shadow 200ms ease-in, font-weight 200ms ease-in-out;
    transition: box-shadow 200ms ease-in, font-weight 200ms ease-in-out; }
.nk-navigation-item__link:focus {
    outline: none;
    box-shadow: 0 0 0 0.25rem rgba(33, 150, 243, 0.2); }
.nk-navigation-item__link:hover {
    color: inherit; }
.nk-navigation-item button {
    background-color: white;
    width: 100%;
    border: none;
    cursor: pointer; }
.nk-navigation-item--is-active {
    border-bottom: 2px #2196F3 solid;
    font-weight: 700; }
.nk-navigation-item--is-active button {
    font-weight: 700; }
.nk-navigation-item--is-active .nk-navigation-item__link:focus {
    box-shadow: none; }
.nk-navigation--size-xs {
    font-size: 0.75rem; }

@charset "UTF-8";
.nk-list {
    margin-bottom: 1rem; }
.nk-list--is-indented {
    padding-left: 1.5rem; }
.nk-list--icon.nk-list--size--xs li::before {
    height: 1.222rem; }
.nk-list li {
    position: relative;
    padding-left: 2rem; }
.nk-list li::before {
    display: inline-block;
    margin-left: -2rem;
    width: 2rem;
    left: 0;
    color: var(--list-bullet-color); }
.nk-list li ul,
.nk-list li ol {
    margin-top: 1rem;
    padding-left: 0; }
.nk-list--ul {
    list-style: none; }
.nk-list--ul > li::before {
    content: '•';
    -webkit-transform: translateX(0.6875rem);
    transform: translateX(0.6875rem); }
.nk-list--icon > li::before {
    content: '' !important;
    height: 1.375rem;
    background: var(--list-image) no-repeat;
    background-size: contain;
    vertical-align: middle; }
.nk-list--size--xs {
    font-size: 0.75rem; }
.nk-list--size--xs--is-indented {
    padding-left: 1.75rem; }
.nk-list--size--xs li::before {
    width: 1.75rem;
    margin-left: -1.75rem; }
.nk-list--ol {
    counter-reset: item; }
.nk-list--ol > li::before {
    counter-increment: item;
    content: counter(item, decimal) ". "; }
.nk-list--ol ol li::before {
    content: counter(item, lower-latin) ". "; }
.nk-list--no-icon::before {
    background: none !important; }

.nk-toggle-group {
    margin-bottom: 2rem; }
.nk-toggle-group--no-stack {
    margin-bottom: 0; }
.nk-toggle-group--no-last-border .nk-toggle:last-child .nk-toggle__label {
    border-bottom-width: 0; }

.nk-toggle {
    position: relative;
    -webkit-transition: ease 200ms background-color;
    transition: ease 200ms background-color; }
.nk-toggle:hover {
    background-color: #f7f7f7; }
.nk-toggle__input {
    opacity: 0;
    width: 0;
    height: 0;
    position: absolute; }
.nk-toggle__label {
    display: block;
    position: relative;
    cursor: pointer;
    padding: 1rem 4.5rem 1rem 1rem;
    border-bottom: 0.0625rem solid #d8d8d8; }
.nk-toggle__visual {
    position: absolute;
    right: 1rem;
    top: 0.625rem; }
.nk-toggle__toggle.nk-icon {
    pointer-events: none;
    fill: #d8d8d8; }
.nk-toggle__toggle.nk-icon rect {
    -webkit-transition: fill 200ms ease;
    transition: fill 200ms ease; }
.nk-toggle__toggle.nk-icon circle {
    -webkit-transition: cx 200ms ease;
    transition: cx 200ms ease; }
.nk-toggle__toggle--checked.nk-icon {
    fill: #2cd664; }

.nk-bold--weight-medium {
    font-weight: 500; }

.nk-bold--weight-bold {
    font-weight: 700; }

.nk-risk-indicator__chili {
    display: inline-block; }

.nk-risk-indicator--size-xs .nk-risk-indicator__chili {
    width: 0.4rem; }

.nk-risk-indicator--size-sm .nk-risk-indicator__chili {
    width: 0.6rem; }

.nk-risk-indicator--size-md .nk-risk-indicator__chili {
    width: 0.8rem; }

.nk-risk-indicator--size-lg .nk-risk-indicator__chili {
    width: 1.2rem; }

.nk-risk-indicator .chili--risk--unset #body {
    fill: #d8d8d8; }

.nk-risk-indicator .chili--risk--unset #stem {
    fill: #adadad; }

.nk-risk-indicator .chili--risk--red #body {
    fill: #f44336; }

.nk-risk-indicator .chili--risk--red #stem {
    fill: #217b3e; }

.nk-risk-indicator .chili--risk--green #body {
    fill: #2fb153; }

.nk-risk-indicator .chili--risk--green #stem {
    fill: #217b3e; }

.nk-risk-indicator .chili--risk--yellow #body {
    fill: #fcb321; }

.nk-risk-indicator .chili--risk--yellow #stem {
    fill: #217b3e; }

/**
 * Apply Mobile First & Group selectors:
 *
 * e.g.
 *
 * .my-icon-example {
 *   width: 12px;
 *   @include nk-small-tablet {
 *     width: 14px;
 *   }
 *   @include nk-tablet {
 *     width: 16px;
 *   }
 *   @include nk-desktop {
 *     width: 18px;
 *   }
 *   @include nk-desktop-large {
 *     width: 20px;
 *   }
 * }
 *
 */
.nk-align--xs-text-align-left {
    text-align: left; }

.nk-align--xs-text-align-center {
    text-align: center; }

.nk-align--xs-text-align-right {
    text-align: right; }

@media (min-width: 524px) {
    .nk-align--sm-text-align-left {
        text-align: left; }
    .nk-align--sm-text-align-center {
        text-align: center; }
    .nk-align--sm-text-align-right {
        text-align: right; } }

@media (min-width: 768px) {
    .nk-align--md-text-align-left {
        text-align: left; }
    .nk-align--md-text-align-center {
        text-align: center; }
    .nk-align--md-text-align-right {
        text-align: right; } }

@media (min-width: 1024px) {
    .nk-align--lg-text-align-left {
        text-align: left; }
    .nk-align--lg-text-align-center {
        text-align: center; }
    .nk-align--lg-text-align-right {
        text-align: right; } }

@media (min-width: 1280px) {
    .nk-align--xl-text-align-left {
        text-align: left; }
    .nk-align--xl-text-align-center {
        text-align: center; }
    .nk-align--xl-text-align-right {
        text-align: right; } }

.RiskLevel__slider, .RiskLevel__overview, .RiskLevel__additional-info {
    margin: 0 0 2rem 0; }

.pot-web__summary-link {
    display: flex;
    justify-content: space-between;
    margin: 0 0 1rem 0; }

.nk-select {
    cursor: pointer;
    outline: none;
    position: relative;
    width: 100%; }
.nk-select--size-xs {
    font-size: 0.75rem; }
.nk-select__wrapper {
    margin-bottom: 1.5rem; }
.nk-select__wrapper.nk-select__wrapper--no-stack {
    margin-bottom: 0; }
.nk-select__label {
    display: block;
    font-size: 0.75rem;
    font-weight: 500;
    color: #424242; }
.nk-select--error .nk-select__header {
    border-bottom-color: #f44336; }
.nk-select--expanded .nk-select__header {
    border-bottom-color: transparent; }
.nk-select--expanded .nk-select__dropdown {
    border-bottom: 1px solid #2196f3; }
.nk-select--expanded .nk-select__header-icon {
    -webkit-transform: rotate(-180deg);
    transform: rotate(-180deg); }
.nk-select--disabled {
    cursor: not-allowed; }
.nk-select--disabled .nk-select__header {
    color: #7c7c7c; }
.nk-select--disabled .nk-select__header:focus {
    border-bottom: 1px solid #adadad; }
.nk-select__header {
    align-items: center;
    border: 1px solid transparent;
    display: flex;
    flex-direction: row;
    flex-wrap: nowrap;
    justify-content: space-between;
    outline: none;
    padding: 0.25rem 0 0.25rem 0;
    line-height: 1.5;
    position: relative;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    border-bottom: 1px solid #adadad; }
.nk-select__header-title {
    display: inline; }
.nk-select__header-icon {
    -webkit-transition: -webkit-transform 0.2s linear;
    transition: -webkit-transform 0.2s linear;
    transition: transform 0.2s linear;
    transition: transform 0.2s linear, -webkit-transform 0.2s linear; }
.nk-select__header:focus {
    border-bottom: 1px solid #2196f3; }
.nk-select__dropdown {
    background-color: white;
    box-shadow: 0 0.125rem 0.5rem 0 rgba(0, 0, 0, 0.2);
    position: absolute;
    left: 0;
    right: 0;
    z-index: 5;
    overflow: hidden;
    /* TODO: Remove $root when we're able to handle different style versions. */ }
.nk-select__dropdown--hide {
    -webkit-transition: max-height 600ms cubic-bezier(0, 1, 0, 1), opacity 200ms ease-in;
    transition: max-height 600ms cubic-bezier(0, 1, 0, 1), opacity 200ms ease-in;
    max-height: 0;
    opacity: 0;
    visibility: hidden; }
.nk-select__dropdown--show {
    max-height: 1000px;
    opacity: 1;
    -webkit-transition: max-height 600ms ease-in, opacity 200ms ease-in;
    transition: max-height 600ms ease-in, opacity 200ms ease-in;
    visibility: visible; }
.nk-select .nk-select__dropdown--restrict-height {
    max-height: 14rem;
    overflow-y: auto; }
.nk-select__option {
    border: 1px solid transparent;
    outline: none;
    padding: 0.5rem 1rem;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none; }
.nk-select__option:focus {
    z-index: 5;
    background-color: #f7f7f7; }

.nk-progress-bar {
    margin-bottom: 1rem; }
.nk-progress-bar__labels, .nk-progress-bar__secondary-labels {
    display: flex;
    justify-content: space-between;
    margin-bottom: 0.5rem; }
.nk-progress-bar__label, .nk-progress-bar__secondary-label {
    margin-bottom: 0; }
.nk-progress-bar__label--right:only-child, .nk-progress-bar__secondary-label--right:only-child {
    margin-left: auto;
    text-align: right; }
.nk-progress-bar__progress {
    display: flex;
    height: 0.625rem;
    border-radius: 0.3125rem;
    overflow: hidden;
    background: #f7f7f7;
    position: relative;
    margin-bottom: 0.5rem; }
.nk-progress-bar__progress__milestone {
    position: absolute;
    height: 0.625rem;
    border-left: 1px solid #adadad; }
.nk-progress-bar__progress__bar {
    background-color: #2fb153;
    height: 0.625rem;
    -webkit-transition: width 300ms cubic-bezier(0.4, 0, 0.2, 1);
    transition: width 300ms cubic-bezier(0.4, 0, 0.2, 1); }
.nk-progress-bar .nk-progress-bar__progress__bar {
    margin-left: 0; }
.nk-progress-bar__progress__bar:first-child {
    border-bottom-left-radius: 0.3125rem;
    border-top-left-radius: 0.3125rem; }
.nk-progress-bar__progress__bar:last-child {
    border-bottom-right-radius: 0.3125rem;
    border-top-right-radius: 0.3125rem; }
.nk-progress-bar__progress__bar--color-matisse {
    background-color: #1a6ca3; }
.nk-progress-bar__progress__bar--color-emerald {
    background-color: #2cd664; }
.nk-progress-bar__progress__bar--color-sea-green {
    background-color: #217b3e; }
.nk-progress-bar__progress__bar--color-killarney {
    background-color: #365e42; }
.nk-progress-bar__progress__bar--color-dodger {
    background-color: #2196f3; }
.nk-progress-bar__progress__bar--color-lightning {
    background-color: #fcb321; }
.nk-progress-bar__progress__bar--color-bigstone {
    background-color: #162b3b; }
.nk-progress-bar__progress__bar--color-cod {
    background-color: #1c1c1c; }
.nk-progress-bar__progress__bar--color-product-primary {
    background-color: #2cd664; }
.nk-progress-bar__progress__bar--color-product-primary.nk-progress-bar__progress__bar--striped {
    background-color: rgba(44, 214, 100, 0.5);
    background-image: repeating-linear-gradient(45deg, transparent 0, transparent 0.4rem, #2cd664 0.4rem, #2cd664 calc(0.4rem + 2px)); }
.nk-progress-bar__progress__bar--color-product-secondary {
    background-color: #3f51b5; }
.nk-progress-bar__progress__bar--color-product-secondary.nk-progress-bar__progress__bar--striped {
    background-color: rgba(63, 81, 181, 0.5);
    background-image: repeating-linear-gradient(45deg, transparent 0, transparent 0.4rem, #3f51b5 0.4rem, #3f51b5 calc(0.4rem + 2px)); }
.nk-progress-bar--labels-bottom {
    display: flex;
    flex-direction: column; }
.nk-progress-bar--labels-bottom .nk-progress-bar__labels,
.nk-progress-bar--labels-top .nk-progress-bar__secondary-labels {
    margin-bottom: 0;
    margin-top: 0.5rem; }
.nk-progress-bar--labels-top .nk-progress-bar__labels,
.nk-progress-bar--labels-bottom .nk-progress-bar__secondary-labels {
    margin-bottom: 0.5rem;
    margin-top: 0; }
.nk-progress-bar--labels-bottom .nk-progress-bar__progress {
    margin-bottom: 0; }

.nk-key {
    background-color: #2fb153;
    border-radius: 0.3125rem;
    height: 0.625rem;
    margin-bottom: 1rem;
    width: 2.5rem; }
.nk-key--color-product-primary {
    background-color: #2cd664; }
.nk-key--color-product-primary.nk-key--striped {
    background-color: rgba(44, 214, 100, 0.5);
    background-image: repeating-linear-gradient(45deg, transparent 0, transparent 0.4rem, #2cd664 0.4rem, #2cd664 calc(0.4rem + 2px)); }
.nk-key--color-product-secondary {
    background-color: #3f51b5; }
.nk-key--color-product-secondary.nk-key--striped {
    background-color: rgba(63, 81, 181, 0.5);
    background-image: repeating-linear-gradient(45deg, transparent 0, transparent 0.4rem, #3f51b5 0.4rem, #3f51b5 calc(0.4rem + 2px)); }

.nk-table {
    margin-bottom: 1rem; }
.nk-table--full-width {
    width: 100%; }
.nk-table--no-stack {
    margin-bottom: 0; }
.nk-table--full-width {
    width: 100%; }
.nk-table--striped .nk-table__body .nk-table__row:nth-child(odd) {
    background-color: #f7f7f7; }
.nk-table--no-striped .nk-table__head .nk-table__row {
    border-bottom: 1px #D8D8D8 solid; }
.nk-table--font-size-xs .nk-table__body {
    font-size: 0.75rem; }
.nk-table--no-wrap {
    white-space: nowrap; }
.nk-table__body .nk-table__row:hover {
    background-color: #d8d8d8 !important; }
.nk-table--align-center {
    text-align: center; }
.nk-table--align-left {
    text-align: left; }
.nk-table--align-right {
    text-align: right; }
.nk-table__cell, .nk-table__head-cell {
    padding: 0.5rem; }
.nk-table__head-cell {
    font-size: 0.75rem;
    font-weight: 500; }

.nk-section--stack-spacing-md {
    margin-bottom: 1rem; }

.nk-section--stack-spacing-xl {
    margin-bottom: 2rem; }

.nk-tab-group__head-group {
    display: flex; }

.nk-tab-group__head-item {
    border-bottom: 1px solid #d8d8d8;
    display: inline-block;
    font-size: 0.75rem;
    line-height: 1.5rem;
    text-align: center;
    width: 100%; }
.nk-tab-group__head-item--selected {
    border-bottom: 0.125rem solid #2196f3;
    font-weight: bold; }
.nk-tab-group__head-item--inline {
    width: auto;
    padding: 0 1.5rem; }
.nk-tab-group__head-item__link, .nk-tab-group__head-item__link:hover {
    color: #424242;
    display: block;
    width: 100%; }

.nk-tab-group__tab-item {
    padding-top: 2rem; }

.nk-animation {
    height: 100%;
    width: 100%;
    margin: auto; }
.nk-animation--size-sm {
    height: 5rem;
    width: 5rem; }
.nk-animation--size-md {
    height: 10rem;
    width: 10rem; }
.nk-animation--size-lg {
    height: 15rem;
    width: 15rem; }

.nk-badge {
    display: inline-block;
    padding: 0;
    margin: 0;
    border-radius: 2px; }
.nk-badge > span {
    display: block;
    line-height: 1; }
.nk-badge > span:not([class*="--color-"]) {
    color: white; }
.nk-badge--xs {
    padding: 0.25rem 0.5rem; }
.nk-badge--sm {
    padding: 0.5rem 1.5rem; }
.nk-badge--md {
    padding: 1rem 2rem; }
.nk-badge--bg-nutmeg-green {
    background-color: #2fb153; }
.nk-badge--bg-emerald {
    background-color: #2cd664; }
.nk-badge--bg-sea-green {
    background-color: #217b3e; }
.nk-badge--bg-killarney {
    background-color: #365e42; }
.nk-badge--bg-bigstone {
    background-color: #162b3b; }
.nk-badge--bg-matisse {
    background-color: #1a6ca3; }
.nk-badge--bg-dodger {
    background-color: #2196f3; }
.nk-badge--bg-cod {
    background-color: #1c1c1c; }
.nk-badge--bg-mineshaft {
    background-color: #424242; }
.nk-badge--bg-boulder {
    background-color: #7c7c7c; }
.nk-badge--bg-chalice {
    background-color: #adadad; }
.nk-badge--bg-haze {
    background-color: #d8d8d8; }
.nk-badge--bg-wildsand {
    background-color: #f7f7f7; }
.nk-badge--bg-lightning {
    background-color: #fcb321; }
.nk-badge--bg-pomegranate {
    background-color: #f44336; }
.nk-badge--bg-crimson {
    background-color: #e91e63; }
.nk-badge--bg-seance {
    background-color: #9c27b0; }
.nk-badge--bg-fuchsia {
    background-color: #673ab7; }
.nk-badge--bg-indigo {
    background-color: #3f51b5; }
.nk-badge--bg-white {
    background-color: white; }
.nk-badge--bg-black {
    background-color: black; }

.nk-text-area {
    margin-bottom: 1.5rem; }
.nk-text-area__input {
    background: transparent;
    border: 1px #adadad solid;
    color: #1c1c1c;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    min-height: 4rem;
    padding: 0.5rem;
    outline: none;
    overflow: auto;
    resize: none;
    width: 100%; }
.nk-text-area__input:focus {
    border-color: #2196f3; }
.nk-text-area__input::-webkit-input-placeholder {
    color: #7c7c7c; }
.nk-text-area__input::-moz-placeholder {
    color: #7c7c7c; }
.nk-text-area__input:-ms-input-placeholder {
    color: #7c7c7c; }
.nk-text-area__input::-ms-input-placeholder {
    color: #7c7c7c; }
.nk-text-area__input::placeholder {
    color: #7c7c7c; }
.nk-text-area__label {
    color: #424242;
    display: block;
    font-size: 0.75rem;
    font-weight: 500;
    margin-bottom: 0.25rem; }
.nk-text-area--error .nk-text-area__input {
    border-color: #f44336; }
.nk-text-area--resizable .nk-text-area__input {
    resize: vertical; }
.nk-text-area--no-stack {
    margin-bottom: 0; }
.nk-text-area--valid .nk-text-area__input {
    border-color: #2fb153; }

.nk-checkbox.nk-checkbox-consent {
    background-color: white;
    border: 1px solid rgba(0, 0, 0, 0);
    border-radius: 2px;
    -webkit-transition: 200ms border-color ease-in-out;
    transition: 200ms border-color ease-in-out; }
.nk-checkbox.nk-checkbox-consent:hover:not(.nk-checkbox--is-disabled) {
    background-color: #f7f7f7;
    border: 1px solid #2fb153; }
.nk-checkbox.nk-checkbox-consent.nk-checkbox--is-checked {
    border: 1px solid #2fb153; }
.nk-checkbox.nk-checkbox-consent.nk-checkbox--is-disabled {
    border: 1px solid rgba(0, 0, 0, 0);
    cursor: not-allowed; }
.nk-checkbox.nk-checkbox-consent .nk-checkbox__label {
    padding: 0.5rem 1.5rem;
    padding-left: 3rem; }
.nk-checkbox.nk-checkbox-consent .nk-checkbox__visual {
    left: 1rem;
    top: 0.75rem;
    right: auto;
    -webkit-transform: none;
    transform: none; }

.nk-checkbox-with-body .nk-checkbox {
    border: 0; }

.nk-checkbox-with-body .nk-checkbox__label {
    padding: 0;
    padding-right: 3rem; }

.nk-checkbox-with-body__body {
    overflow: hidden; }
.nk-checkbox-with-body__body--collapsed {
    max-height: 0;
    -webkit-transition: max-height 200ms cubic-bezier(0.4, 0, 0.2, 1);
    transition: max-height 200ms cubic-bezier(0.4, 0, 0.2, 1); }
.nk-checkbox-with-body__body--expanded {
    max-height: 5000px;
    -webkit-transition: max-height 600ms ease-in-out;
    transition: max-height 600ms ease-in-out; }

.nk-checkbox {
    position: relative;
    border-bottom: 1px solid #d8d8d8;
    margin-bottom: 1.5rem; }
.nk-checkbox__input {
    width: 0;
    height: 0;
    opacity: 0;
    position: absolute; }
.nk-checkbox__label {
    cursor: pointer;
    display: block;
    line-height: 1;
    padding: 1rem 2rem 1rem 0.5rem; }
.nk-checkbox--is-disabled .nk-checkbox__label {
    pointer-events: none;
    cursor: default; }
.nk-checkbox__visual {
    position: absolute;
    right: 0.5rem;
    top: 50%;
    -webkit-transform: translateY(-50%);
    transform: translateY(-50%); }
.nk-checkbox__checkbox-icon.nk-icon {
    border-radius: 2px;
    border: 1px solid #424242;
    color: rgba(0, 0, 0, 0);
    display: block; }
.nk-checkbox--is-checked .nk-checkbox__checkbox-icon {
    background-color: #2fb153;
    border-color: #2fb153;
    color: white; }
.nk-checkbox--is-disabled .nk-checkbox__checkbox-icon {
    border-color: #adadad; }
.nk-checkbox--is-disabled.nk-checkbox--is-checked .nk-checkbox__checkbox-icon {
    background-color: #adadad; }
.nk-checkbox--no-stack {
    margin-bottom: 0; }

.check-circle #dot,
.check-circle #tick {
    fill: none; }

.check-circle--is-active #tick {
    fill: none; }

.check-circle--is-complete #dot {
    fill: none; }

.toggle--is-active #toggle-handle {
    -webkit-transform: translateX(16.8px);
    transform: translateX(16.8px); }

.chili--risk--unset #body {
    fill: #d8d8d8; }

.chili--risk--unset #stem {
    fill: #adadad; }

.chili--risk--red #body {
    fill: #f44336; }

.chili--risk--red #stem {
    fill: #217b3e; }

.chili--risk--green #body {
    fill: #2fb153; }

.chili--risk--green #stem {
    fill: #217b3e; }

.chili--risk--yellow #body {
    fill: #fcb321; }

.chili--risk--yellow #stem {
    fill: #217b3e; }

.nk-pagination {
    margin-bottom: 1.5rem; }
.nk-pagination--no-stack {
    margin-bottom: 0; }
.nk-pagination .nk-button--is-disabled {
    color: #d8d8d8; }
.nk-pagination .nk-button:hover, .nk-pagination .nk-button:active {
    color: #2196f3; }
.nk-pagination--text-container {
    vertical-align: middle;
    padding: 0 0.5rem; }

/**
 * Apply Mobile First & Group selectors:
 *
 * e.g.
 *
 * .my-icon-example {
 *   width: 12px;
 *   @include nk-small-tablet {
 *     width: 14px;
 *   }
 *   @include nk-tablet {
 *     width: 16px;
 *   }
 *   @include nk-desktop {
 *     width: 18px;
 *   }
 *   @include nk-desktop-large {
 *     width: 20px;
 *   }
 * }
 *
 */
.nk-description-list {
    display: flex;
    flex-wrap: wrap; }
.nk-description-list__primary-text--term .nk-description-list__term {
    font-weight: 700; }
.nk-description-list__primary-text--details .nk-description-list__details {
    font-weight: 700; }
@media (max-width: 523px) {
    .nk-description-list__term, .nk-description-list__details {
        flex-basis: 100%; }
    .nk-description-list__details {
        margin-bottom: 0.5rem; } }
@media (min-width: 524px) {
    .nk-description-list__term, .nk-description-list__details {
        flex-basis: 50%; }
    .nk-description-list__details {
        text-align: right;
        margin-bottom: 1rem; } }
.nk-description-list > *:last-child {
    margin-bottom: 0; }

.nk-download-box {
    border-radius: 2px;
    position: relative;
    -webkit-transition: 200ms box-shadow ease-in;
    transition: 200ms box-shadow ease-in;
    display: flex;
    align-items: center;
    width: 100%;
    padding: 1rem;
    border: 2px solid transparent;
    border-radius: 2px;
    background-color: white;
    -webkit-transition: 200ms border-color ease-in-out;
    transition: 200ms border-color ease-in-out; }
.nk-download-box:focus {
    outline: none;
    box-shadow: 0 0 0 0.25rem rgba(33, 150, 243, 0.2); }
.nk-download-box__text {
    flex: 1 1; }
.nk-download-box__icon {
    margin-left: 1rem; }
.nk-download-box:hover {
    border-color: #2196f3; }
.nk-download-box:hover .nk-download-box__icon #icon-download-file__arrow {
    -webkit-animation: download-file-arrow-bounce 600ms;
    animation: download-file-arrow-bounce 600ms; }

@-webkit-keyframes download-file-arrow-bounce {
    0%,
    100% {
        -webkit-transform: translateY(0);
        transform: translateY(0); }
    30% {
        -webkit-transform: translateY(0.6px);
        transform: translateY(0.6px); }
    60% {
        -webkit-transform: translateY(-0.3px);
        transform: translateY(-0.3px); } }

@keyframes download-file-arrow-bounce {
    0%,
    100% {
        -webkit-transform: translateY(0);
        transform: translateY(0); }
    30% {
        -webkit-transform: translateY(0.6px);
        transform: translateY(0.6px); }
    60% {
        -webkit-transform: translateY(-0.3px);
        transform: translateY(-0.3px); } }

.nk-footer {
    width: 100%;
    color: #7c7c7c;
    position: absolute;
    bottom: 0; }
.nk-footer__container {
    margin-top: 1.5rem;
    background-color: white;
    padding: 1.5rem 0; }
.nk-footer--no-bottom-fixed {
    position: relative; }

.nk-input-group {
    display: flex;
    margin-bottom: 1.5rem; }
.nk-input-group .nk-input-group__item {
    margin: 0; }
.nk-input-group .nk-input-group__item:first-child {
    border-top-right-radius: 0;
    border-bottom-right-radius: 0; }
.nk-input-group .nk-input-group__item:last-child {
    border-top-left-radius: 0;
    border-bottom-left-radius: 0; }
.nk-input-group .nk-input-group__item.nk-button {
    padding-top: 0;
    padding-bottom: 0;
    -webkit-transform: translateY(1px);
    transform: translateY(1px); }
.nk-input-group .nk-input-group__item.nk-input:first-child input {
    padding-right: 1rem; }
.nk-input-group .nk-input-group__item.nk-input:last-child input {
    padding-left: 1rem; }
.nk-input-group--fluid {
    width: 100%; }
.nk-input-group--fluid .nk-input-group__item.nk-input {
    flex: 1 1;
    min-width: 0;
    width: 100%; }

.nk-nav-arrows .nk-nav-arrows__next-btn {
    text-align: right; }

.nk-nav-arrows .nk-nav-arrows__next-btn--disabled,
.nk-nav-arrows .nk-nav-arrows__prev-btn--disabled {
    color: #d8d8d8; }

.nk-progress-steps {
    position: relative;
    margin-bottom: 1.5rem;
    z-index: 1; }
.nk-progress-steps__steps {
    display: flex;
    list-style: none;
    padding: 0;
    position: relative;
    justify-content: space-between;
    width: 100%; }
.nk-progress-steps__step {
    flex: 1 1;
    display: flex;
    position: relative;
    flex-direction: column;
    align-items: center; }
.nk-progress-steps__step:not(:last-child)::after {
    background-color: #d8d8d8;
    content: '';
    display: block;
    position: absolute;
    height: 0.125rem;
    top: 0.75rem;
    left: 1.5rem;
    -webkit-transform: translate3d(50%, -50%, 0);
    transform: translate3d(50%, -50%, 0);
    width: calc(100% - 1.5rem);
    z-index: -1; }
.nk-progress-steps__step svg path#circle {
    fill: #d8d8d8; }
.nk-progress-steps__step svg circle#dot {
    fill: none; }
.nk-progress-steps__step svg path#tick {
    fill: none; }
.nk-progress-steps__step__label {
    font-size: 0.75rem;
    line-height: 1;
    color: #7c7c7c;
    padding-top: 1rem; }
.nk-progress-steps__step--is-complete svg#circle, .nk-progress-steps__step--is-active svg#circle {
    fill: #2fb153; }
.nk-progress-steps__step--is-complete .nk-progress-steps__step__label, .nk-progress-steps__step--is-active .nk-progress-steps__step__label {
    color: #2fb153; }
.nk-progress-steps__step--is-complete:not(:last-child)::after {
    background-color: #2fb153; }
.nk-progress-steps__step--is-complete svg path#circle {
    fill: #2fb153; }
.nk-progress-steps__step--is-complete svg circle#dot {
    fill: none; }
.nk-progress-steps__step--is-complete svg path#tick {
    fill: #2fb153; }
.nk-progress-steps__step--is-active:not(:last-child)::after {
    background-color: #d8d8d8; }
.nk-progress-steps__step--is-active svg path#circle {
    fill: #2fb153; }
.nk-progress-steps__step--is-active svg circle#dot {
    fill: #2fb153; }
.nk-progress-steps__step--is-active svg path#tick {
    fill: none; }

.nk-search-box {
    margin-bottom: 1.5rem; }
.nk-search-box__list {
    margin-top: -1.5rem;
    max-height: 13rem;
    overflow: scroll;
    border: 1px solid #d8d8d8;
    border-top: none; }
.nk-search-box__list__item {
    cursor: pointer;
    width: 100%;
    background-color: white;
    border: 0;
    color: #424242;
    line-height: 2.75rem;
    padding: 0 1rem;
    text-align: left; }
.nk-search-box__list__item:hover, .nk-search-box__list__item:focus {
    outline: none;
    background: #f7f7f7; }

.nk-stepper {
    display: flex;
    flex-direction: column;
    justify-content: center; }
.nk-stepper__control {
    border-radius: 2px;
    position: relative;
    -webkit-transition: 200ms box-shadow ease-in;
    transition: 200ms box-shadow ease-in;
    border-radius: 50%;
    cursor: pointer; }
.nk-stepper__control:focus {
    outline: none;
    box-shadow: 0 0 0 0.25rem rgba(33, 150, 243, 0.2); }
.nk-stepper__label {
    font-weight: 500;
    margin-bottom: 1rem;
    text-align: center; }
.nk-stepper__controls {
    align-items: center;
    display: flex;
    justify-content: space-between; }
.nk-stepper__prefix {
    color: #2196f3; }
.nk-stepper__wrapper {
    display: flex;
    justify-content: center;
    margin: 0 1.25rem;
    padding: 0 1rem;
    position: relative;
    min-width: 9rem;
    color: #2196f3;
    font-size: 1.5rem; }
.nk-stepper__wrapper::after {
    content: '';
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    border-bottom: solid 1px #2196f3; }
.nk-stepper__value-sizer {
    position: absolute;
    height: 0;
    overflow: hidden;
    white-space: pre; }
.nk-stepper__value, .nk-stepper__value-sizer {
    font-size: 1.5rem; }
.nk-stepper__value--numeric {
    border: none;
    outline: none;
    background-color: transparent;
    color: #2196f3; }
.nk-stepper__value--numeric::-webkit-inner-spin-button, .nk-stepper__value--numeric::-webkit-outer-spin-button {
    -webkit-appearance: none;
    appearance: none;
    margin: 0; }

.nk-tickets__item {
    background-color: white;
    position: relative;
    overflow: hidden; }
.nk-tickets__item__inner {
    border: 1px solid #D8D8D8;
    border-bottom: 2px dotted #D8D8D8;
    border-top: 0; }
.nk-tickets__item__space--stretch--md .nk-tickets__item__inner {
    padding: 1rem 0.5rem; }
.nk-tickets__item__space--stretch--lg .nk-tickets__item__inner {
    padding: 1.5rem 1rem; }
.nk-tickets__item__space--inset--sm .nk-tickets__item__inner {
    padding: 0.5rem; }
.nk-tickets__item__space--inset--md .nk-tickets__item__inner {
    padding: 1rem; }
.nk-tickets__item__space--inset--lg .nk-tickets__item__inner {
    padding: 1.5rem; }
.nk-tickets__item__space--none .nk-tickets__item__inner {
    padding: 0; }
.nk-tickets__item__first .nk-tickets__item__inner {
    border-top: 1px solid #D8D8D8; }
.nk-tickets__item__last .nk-tickets__item__inner {
    border-bottom: 1px solid #D8D8D8; }
.nk-tickets__item__corner__top, .nk-tickets__item__corner__bottom {
    position: absolute;
    width: 1.6rem;
    height: 1.6rem;
    border-radius: 100%;
    background-color: #f7f7f7;
    border: 1px solid #D8D8D8; }
.nk-tickets__item__corner__top {
    top: -0.8rem; }
.nk-tickets__item__corner__bottom {
    bottom: -0.8rem; }
.nk-tickets__item__corner__left {
    left: -0.8rem; }
.nk-tickets__item__corner__right {
    right: -0.8rem; }

.nk-tooltip {
    background-color: #1c1c1c;
    border-radius: 4px;
    color: white;
    display: inline-block;
    padding: 0.5rem;
    pointer-events: none;
    position: relative;
    max-width: 11.25rem;
    will-change: transform;
    z-index: 900; }
.nk-tooltip__arrow {
    position: absolute;
    height: 0;
    width: 0; }
.nk-tooltip__arrow--top, .nk-tooltip__arrow--bottom {
    border-left: 8px solid transparent;
    border-right: 8px solid transparent;
    left: calc(50% - 8px); }
.nk-tooltip__arrow--left, .nk-tooltip__arrow--right {
    border-bottom: 8px solid transparent;
    border-top: 8px solid transparent;
    top: calc(50% - 8px); }
.nk-tooltip__arrow--top {
    border-top: 8px solid #1c1c1c;
    bottom: -8px; }
.nk-tooltip__arrow--bottom {
    border-bottom: 8px solid #1c1c1c;
    top: -8px; }
.nk-tooltip__arrow--left {
    border-left: 8px solid #1c1c1c;
    right: -8px; }
.nk-tooltip__arrow--right {
    border-right: 8px solid #1c1c1c;
    left: -8px; }
.nk-tooltip__label {
    line-height: 1.6; }
.nk-tooltip__target {
    cursor: pointer;
    display: inline-block;
    position: relative; }
.nk-tooltip__target + .nk-tooltip {
    opacity: 0;
    position: absolute; }
.nk-tooltip__target + .nk-tooltip--fade-in {
    opacity: 1;
    -webkit-transition: opacity;
    transition: opacity;
    -webkit-transition-delay: 300ms;
    transition-delay: 300ms;
    -webkit-transition-duration: 200ms;
    transition-duration: 200ms;
    -webkit-transition-timing-function: ease-in;
    transition-timing-function: ease-in; }
.nk-tooltip__target + .nk-tooltip--top {
    margin-bottom: 8px; }
.nk-tooltip__target + .nk-tooltip--bottom {
    margin-top: 8px; }
.nk-tooltip__target + .nk-tooltip--left {
    margin-right: 8px; }
.nk-tooltip__target + .nk-tooltip--right {
    margin-left: 8px; }
.nk-tooltip__target + .nk-tooltip--no-margin {
    margin: 0; }

.nk-user-quote {
    display: flex;
    flex-direction: row;
    flex-wrap: nowrap;
    margin-bottom: 1rem; }
.nk-user-quote svg {
    display: block; }
.nk-user-quote__icon {
    flex: 0 0 1.5rem;
    height: 1.5rem; }
.nk-user-quote__content {
    background-color: #f7f7f7;
    border-radius: 16px;
    border-top-left-radius: 0;
    flex: 1 1 auto;
    margin-left: 0.5rem;
    padding: 1rem;
    word-break: break-word; }

.pot-web__summary-link {
    display: flex;
    justify-content: space-between;
    margin: 0 0 1rem 0; }

/**
 *  Bootstrap 4 Breakpoints
*/

/*! normalize.css v8.0.1 | MIT License | github.com/necolas/normalize.css */
/* Document
   ========================================================================== */
/**
 * 1. Correct the line height in all browsers.
 * 2. Prevent adjustments of font size after orientation changes in iOS.
 */
/*html {*/
/*    line-height: 1.15;*/
/*    !* 1 *!*/
/*    -webkit-text-size-adjust: 100%;*/
/*    !* 2 *! }*/

/* Sections
   ========================================================================== */
/**
 * Remove the margin in all browsers.
 */
body {
    margin: 0; }

/**
 * Render the `main` element consistently in IE.
 */
main {
    display: block; }

/**
 * Correct the font size and margin on `h1` elements within `section` and
 * `article` contexts in Chrome, Firefox, and Safari.
 */
/*h1 {*/
/*    font-size: 2em;*/
/*    margin: 0.67em 0; }*/

/* Grouping content
   ========================================================================== */
/**
 * 1. Add the correct box sizing in Firefox.
 * 2. Show the overflow in Edge and IE.
 */
hr {
    box-sizing: content-box;
    /* 1 */
    height: 0;
    /* 1 */
    overflow: visible;
    /* 2 */ }

/**
 * 1. Correct the inheritance and scaling of font size in all browsers.
 * 2. Correct the odd `em` font sizing in all browsers.
 */
pre {
    font-family: monospace, monospace;
    /* 1 */
    font-size: 1em;
    /* 2 */ }

/* Text-level semantics
   ========================================================================== */
/**
 * Remove the gray background on active links in IE 10.
 */
a {
    background-color: transparent; }

/**
 * 1. Remove the bottom border in Chrome 57-
 * 2. Add the correct text decoration in Chrome, Edge, IE, Opera, and Safari.
 */
abbr[title] {
    border-bottom: none;
    /* 1 */
    text-decoration: underline;
    /* 2 */
    -webkit-text-decoration: underline dotted;
    text-decoration: underline dotted;
    /* 2 */ }

/**
 * Add the correct font weight in Chrome, Edge, and Safari.
 */
b,
strong {
    font-weight: bolder; }

/**
 * 1. Correct the inheritance and scaling of font size in all browsers.
 * 2. Correct the odd `em` font sizing in all browsers.
 */
code,
kbd,
samp {
    font-family: monospace, monospace;
    /* 1 */
    font-size: 1em;
    /* 2 */ }

/**
 * Add the correct font size in all browsers.
 */
small {
    font-size: 80%; }

/**
 * Prevent `sub` and `sup` elements from affecting the line height in
 * all browsers.
 */
sub,
sup {
    font-size: 75%;
    line-height: 0;
    position: relative;
    vertical-align: baseline; }

sub {
    bottom: -0.25em; }

sup {
    top: -0.5em; }

/* Embedded content
   ========================================================================== */
/**
 * Remove the border on images inside links in IE 10.
 */
img {
    border-style: none; }

/* Forms
   ========================================================================== */
/**
 * 1. Change the font styles in all browsers.
 * 2. Remove the margin in Firefox and Safari.
 */
button,
input,
optgroup,
select,
textarea {
    font-family: inherit;
    /* 1 */
    font-size: 100%;
    /* 1 */
    line-height: 1.15;
    /* 1 */
    margin: 0;
    /* 2 */ }

/**
 * Show the overflow in IE.
 * 1. Show the overflow in Edge.
 */
button,
input {
    /* 1 */
    overflow: visible; }

/**
 * Remove the inheritance of text transform in Edge, Firefox, and IE.
 * 1. Remove the inheritance of text transform in Firefox.
 */
button,
select {
    /* 1 */
    text-transform: none; }

/**
 * Correct the inability to style clickable types in iOS and Safari.
 */
button,
[type="button"],
[type="reset"],
[type="submit"] {
    -webkit-appearance: button; }

/**
 * Remove the inner border and padding in Firefox.
 */
button::-moz-focus-inner,
[type="button"]::-moz-focus-inner,
[type="reset"]::-moz-focus-inner,
[type="submit"]::-moz-focus-inner {
    border-style: none;
    padding: 0; }

/**
 * Restore the focus styles unset by the previous rule.
 */
button:-moz-focusring,
[type="button"]:-moz-focusring,
[type="reset"]:-moz-focusring,
[type="submit"]:-moz-focusring {
    outline: 1px dotted ButtonText; }

/**
 * Correct the padding in Firefox.
 */
fieldset {
    padding: 0.35em 0.75em 0.625em; }

/**
 * 1. Correct the text wrapping in Edge and IE.
 * 2. Correct the color inheritance from `fieldset` elements in IE.
 * 3. Remove the padding so developers are not caught out when they zero out
 *    `fieldset` elements in all browsers.
 */
legend {
    box-sizing: border-box;
    /* 1 */
    color: inherit;
    /* 2 */
    display: table;
    /* 1 */
    max-width: 100%;
    /* 1 */
    padding: 0;
    /* 3 */
    white-space: normal;
    /* 1 */ }

/**
 * Add the correct vertical alignment in Chrome, Firefox, and Opera.
 */
progress {
    vertical-align: baseline; }

/**
 * Remove the default vertical scrollbar in IE 10+.
 */
textarea {
    overflow: auto; }

/**
 * 1. Add the correct box sizing in IE 10.
 * 2. Remove the padding in IE 10.
 */
[type="checkbox"],
[type="radio"] {
    box-sizing: border-box;
    /* 1 */
    padding: 0;
    /* 2 */ }

/**
 * Correct the cursor style of increment and decrement buttons in Chrome.
 */
[type="number"]::-webkit-inner-spin-button,
[type="number"]::-webkit-outer-spin-button {
    height: auto; }

/**
 * 1. Correct the odd appearance in Chrome and Safari.
 * 2. Correct the outline style in Safari.
 */
[type="search"] {
    -webkit-appearance: textfield;
    /* 1 */
    outline-offset: -2px;
    /* 2 */ }

/**
 * Remove the inner padding in Chrome and Safari on macOS.
 */
[type="search"]::-webkit-search-decoration {
    -webkit-appearance: none; }

/**
 * 1. Correct the inability to style clickable types in iOS and Safari.
 * 2. Change font properties to `inherit` in Safari.
 */
::-webkit-file-upload-button {
    -webkit-appearance: button;
    /* 1 */
    font: inherit;
    /* 2 */ }

/* Interactive
   ========================================================================== */
/*
 * Add the correct display in Edge, IE 10+, and Firefox.
 */
details {
    display: block; }

/*
 * Add the correct display in all browsers.
 */
summary {
    display: list-item; }

/* Misc
   ========================================================================== */
/**
 * Add the correct display in IE 10+.
 */
template {
    display: none; }

/**
 * Add the correct display in IE 10.
 */
[hidden] {
    display: none; }

/* http://meyerweb.com/eric/tools/css/reset/
   v3.0 | 20180413
   License: none (public domain)
*/
/*html, body, div, span, applet, object, iframe,*/
/*h1, h2, h3, h4, h5, h6, p, blockquote, pre,*/
/*a, abbr, acronym, address, big, cite, code,*/
/*del, dfn, em, img, ins, kbd, q, s, samp,*/
/*small, strike, strong, sub, sup, tt, var,*/
/*b, u, i, center,*/
/*dl, dt, dd, ol, ul, li,*/
/*fieldset, form, label, legend,*/
/*table, caption, tbody, tfoot, thead, tr, th, td,*/
/*article, aside, canvas, details, embed,*/
/*figure, figcaption, footer, header, hgroup,*/
/*main, menu, nav, output, ruby, section, summary,*/
/*time, mark, audio, video {*/
/*    margin: 0;*/
/*    padding: 0;*/
/*    border: 0;*/
/*    font-size: 100%;*/
/*    font: inherit;*/
/*    vertical-align: baseline; }*/

/* HTML5 display-role reset for older browsers */
article, aside, details, figcaption, figure,
footer, header, hgroup, main, menu, nav, section {
    display: block; }

/* HTML5 hidden-attribute fix for newer browsers */
*[hidden] {
    display: none; }

/*body {*/
/*    line-height: 1; }*/

ol, ul {
    list-style: none; }

blockquote, q {
    quotes: none; }

blockquote:before, blockquote:after,
q:before, q:after {
    content: '';
    content: none; }

table {
    border-collapse: collapse;
    border-spacing: 0; }

@font-face {
    font-family: "Gotham SSm";
    src: url(static/media/GothamSSm-Light.4108bbd7.woff2) format("woff2"), url(static/media/GothamSSm-Light.9e5cc527.woff) format("woff"), url(static/media/GothamSSm-Light.7c996ab9.otf) format("opentype");
    font-style: normal;
    font-weight: 400; }

@font-face {
    font-family: "Gotham SSm";
    src: url(static/media/GothamSSm-Book.852c8b4f.woff2) format("woff2"), url(static/media/GothamSSm-Book.1e26e320.woff) format("woff"), url(static/media/GothamSSm-Book.0908fc08.otf) format("opentype");
    font-style: normal;
    font-weight: 500; }

@font-face {
    font-family: "Gotham SSm";
    src: url(static/media/GothamSSm-Medium.db0a8d46.woff2) format("woff2"), url(static/media/GothamSSm-Medium.9629950b.woff) format("woff"), url(static/media/GothamSSm-Medium.25efd235.otf) format("opentype");
    font-style: normal;
    font-weight: 700; }

/** {*/
/*    box-sizing: border-box; }*/

html {
    height: 100%; }

/*body {*/
/*    color: #424242;*/
/*    font-family: "Gotham SSm", sans-serif;*/
/*    font-size: 1rem;*/
/*    font-weight: 400;*/
/*    line-height: 1.625;*/
/*    background-color: inherit;*/
/*    position: relative;*/
/*    min-height: 100%; }*/

a {
    color: #2196f3;
    text-decoration: none; }
a:hover {
    color: #1a6ca3; }

hr {
    border: none;
    border-bottom: 1px solid #d8d8d8;
    margin-bottom: 1rem; }

strong,
b {
    font-weight: 700; }

/* To be placed on the <body> tag */
.nk-prevent-scroll {
    overflow: hidden; }

.center {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 100vh; }

.debug {
    background-image: -webkit-gradient(linear, left top, right bottom, from(#e5e5e5), to(#f7f7f7));
    background-image: linear-gradient(to bottom right, #e5e5e5, #f7f7f7); }
.debug > * {
    margin-bottom: 0 !important; }

.circle {
    color: white;
    font-size: 0.75rem;
    display: block;
    width: 4.2rem;
    height: 4.2rem;
    border-radius: 50%;
    background-color: #3F51B5;
    text-align: center;
    line-height: 4.2rem; }
.circle--secondary {
    background-color: #2CD664; }

.margin-right-1 {
    margin-right: 1rem; }

.debug-allow-margin-bottom {
    background-image: -webkit-gradient(linear, left top, right bottom, from(#e8e8e8), to(#b6f3ff));
    background-image: linear-gradient(to bottom right, #e8e8e8, #b6f3ff); }

.height-fix-500 {
    height: 500px; }

.height-320 {
    min-height: 320px; }

.height-500 {
    min-height: 500px; }

.width-320 {
    width: 320px; }

.width-500 {
    width: 500px; }

.max-width-500 {
    max-width: 500px; }

.width-768 {
    width: 768px; }

.width-1280 {
    width: 1280px; }

.width-100p {
    width: 100%; }

.width-80p {
    width: 80%;
    margin: auto; }

.space-items {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between; }
.space-items > * {
    margin: 2rem;
    flex: 0 0 6rem; }
.space-items .nk-icon,
.space-items .nk-animation {
    margin-bottom: 0.5rem; }

.style-container {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    width: 800px;
    flex-wrap: wrap; }
.style-container .style-block {
    border-radius: 2px;
    padding: 1rem;
    min-width: 12rem;
    margin-bottom: 0.5rem;
    text-align: center; }

.padded-container {
    padding: 1rem; }

.position--relative {
    position: relative; }

.no-stack-text .nk-text {
    margin-bottom: 0; }



.nk-progress-steps__step svg path#circle {
    fill: #d8d8d8; }
.nk-progress-steps__step svg circle#dot {
    fill: none; }
.nk-progress-steps__step svg path#tick {
    fill: none; }

.slds-form-element, .slds-input {
    width: 100%;
}
.consent > .slds-form-element, .slds-input {
    width: auto;
}
.nk-panel .nk-panel {
    border: none;
    box-shadow: none;
}
.nk-panel .nk-panel .nk-panel__body {
    padding: 0.5rem 2rem;
}
.nk-panel .nk-text--style-title-2 {
    font-size: 1.25rem;
}
.nk-panel .nk-panel .nk-text--style-title-2 {
    font-size: 1rem;
}

.nk-button--secondary {
    background-color: #ffffff;
}



.slds-input:focus {
    box-shadow: none;
}

/*# sourceMappingURL=main.css.map*/