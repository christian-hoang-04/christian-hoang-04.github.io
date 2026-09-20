$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$baseUrl = 'https://www.vilda.net'
$pages = @('about', 'research')
$displayName = 'Christian Hoang'
$avatarSource = 'C:\Users\THINKPAD\Downloads\images.jpg'
$assetRoots = @((Join-Path $root 'src'), (Join-Path $root 'img'))
$posterMap = [ordered]@{
  'https://github.com/zouharvi/pearmut/raw/main/misc/poster_nofont.svg' = 'img/poster-pearmut.svg'
  'https://github.com/zouharvi/mt-breaker/raw/main/poster_nofont.svg' = 'img/poster-mt-breaker.svg'
  'https://github.com/zouharvi/COMET-early-exit/raw/main/meta/poster_nofont.svg' = 'img/poster-comet-early-exit.svg'
  'https://raw.githubusercontent.com/zouharvi/subset2evaluate/refs/heads/main/misc/poster_nofont.svg' = 'img/poster-subset2evaluate.svg'
  'https://github.com/zouharvi/COMET-poly/raw/main/meta/poster_nofont.svg' = 'img/poster-comet-poly.svg'
  'https://github.com/zouharvi/translation-difficulty-estimation/raw/main/misc/poster_nofont.svg' = 'img/poster-translation-difficulty.svg'
  'https://github.com/juliusc/bayesopt_reranking/raw/main/meta/poster_path.svg' = 'img/poster-bayesopt.svg'
  'https://github.com/wmt-conference/ErrorSpanAnnotation/raw/main/misc/poster_ESA.png' = 'img/poster-esa.png'
  'https://github.com/wmt-conference/ErrorSpanAnnotation/raw/main/misc/poster_ESAAI.png' = 'img/poster-esaai.png'
  'https://raw.githubusercontent.com/PinzhenChen/sacreCOMET/main/misc/poster.png' = 'img/poster-sacrecomet.png'
  'https://github.com/zouharvi/tokenization-principle/raw/main/meta/poster_path.svg' = 'img/poster-tokenization-principle.svg'
  'https://github.com/zouharvi/formal-bpe/raw/master/meta/poster_nofont.svg' = 'img/poster-formal-bpe.svg'
  'https://raw.githubusercontent.com/mcognetta/distributional-properties-of-subword-regularization/315e21da30c4e2a8b647cdce1ee041f21531fb76/misc/poster_path.svg' = 'img/poster-distributional-tokenization.svg'
  'https://github.com/zouharvi/bio-mqm-dataset/blob/main/poster.png?raw=true' = 'img/poster-bio-mqm.png'
  'https://github.com/zouharvi/trust-intervention/raw/main/meta/poster_nofont.svg' = 'img/poster-trust-intervention.svg'
}

foreach ($assetRoot in $assetRoots) {
  New-Item -ItemType Directory -Force -Path $assetRoot | Out-Null
}

if (-not (Test-Path -LiteralPath $avatarSource)) {
  throw "Avatar source not found: $avatarSource"
}
Copy-Item -LiteralPath $avatarSource -Destination (Join-Path $root 'src/avatar.jpg') -Force

function Save-TextFile {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Text
  )

  $utf8 = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($Path, $Text, $utf8)
}

function Download-Asset {
  param(
    [Parameter(Mandatory = $true)][string]$RelativePath
  )

  $cleanPath = ($RelativePath -split '\?')[0].TrimStart('/')
  if ($cleanPath -notmatch '^(src|img)/') {
    return
  }

  $target = Join-Path $root ($cleanPath -replace '/', [IO.Path]::DirectorySeparatorChar)
  $parent = Split-Path -Parent $target
  New-Item -ItemType Directory -Force -Path $parent | Out-Null
  if (-not (Test-Path -LiteralPath $target)) {
    Invoke-WebRequest -Uri "$baseUrl/$cleanPath" -UseBasicParsing -OutFile $target
  }
}

$researchContent = @'
<h4>Publications</h4>

<div class='paper_details paper_details_withimg'>
  <div class='paper_title'>SilVar: Speech-Driven Multimodal Model for Reasoning Visual Question Answering and Object Localization</div>
  <span class='authors_span'>EMNLP 2025;&nbsp;&nbsp;&nbsp;Tan-Hanh Pham, Christian Hoang, Phu-Vinh Nguyen, Chris Ngo, Truong Son Hy</span>
  <div style='margin-top: 5px;'><a href='https://aclanthology.org/2025.emnlp-main.589.pdf' class='paper_details_link'>paper</a><a href='https://github.com/Hanhpt23/SilVar' class='paper_details_link'>code</a></div>
  <img class='project_visual project_visual_silvar' src='img/project-silvar.png' alt='SilVar paper figure showing the speech-driven multimodal model' loading='lazy'>
  <div style='margin-top: 5px;'><b>Abstract:</b> Visual Language Models have demonstrated remarkable capabilities across various tasks, including visual question answering and image captioning. However, most models rely on text-based instructions, limiting their effectiveness in natural human-machine interactions. Moreover, the quality of language models primarily depends on reasoning and prompting techniques, such as chain-of-thought, which remain underexplored when using speech instructions. To address these challenges, we propose SilVar, an end-to-end multimodal model that leverages speech instructions for reasoning-based visual question answering. Additionally, we investigate reasoning techniques at different levels, including conversational, simple, and complex speech instructions. SilVar is built upon CLIP, Whisper, and LLaMA 3.1-8B, enabling more intuitive interactions by allowing users to provide verbal or text-based instructions. To this end, we introduce a new dataset designed to challenge models with speech-based reasoning tasks for object localization. This dataset enhances the model&rsquo;s ability to process and explain visual scenes from spoken input, moving beyond simple object recognition to reasoning-based interactions. To our knowledge, SilVar is the first open-source, speech-driven VLM. We believe SilVar will inspire the next generation of multimodal reasoning models, advancing toward expert artificial general intelligence.</div>
</div>

<div class='paper_details paper_details_withimg'>
  <div class='paper_title'>How Perturbations Propagate: A Multi-Level Analysis of Robustness in Large Language Models</div>
  <span class='authors_span'>Ongoing;&nbsp;&nbsp;&nbsp;Dun Li Chan, Emily Liu, Niyathi Allu, Christian Hoang</span>
  <div style='margin-top: 5px;'><a href='https://arxiv.org/pdf/2609.03322' class='paper_details_link'>paper</a><a href='https://github.com/emilyzfliu/decoding-robustness' class='paper_details_link'>code</a></div>
  <img class='project_visual project_visual_perturbations' src='img/project-perturbations.png' alt='Heatmaps showing perturbation propagation across layers' loading='lazy'>
  <div style='margin-top: 5px;'><b>Abstract:</b> Language models encounter typos, corrupted text, altered words, and disrupted token order, yet robustness is usually evaluated only through output behavior. We study how six naturalistic and synthetic input perturbations propagate through decoder-only language models at three levels: output behavior, hidden-state geometry, and attention-head function. We evaluate behavioral effects across four GPT-2 and two Qwen2.5 checkpoints by analyzing layerwise geometry using centered kernel alignment and intrinsic dimension, and examine attention-head responses in GPT-2. Perturbation types produce distinguishable metric profiles that are not fully captured by output measures and are only partly consistent across the tested checkpoints. Copying scores are especially associated with activation-patching recovery under token substitution and shuffling. Gradient-guided HotFlip perturbations also cause stronger behavioral and representational disruption than rate-matched random token substitutions in GPT-2; their behavioral effects are consistent across all six tested checkpoints. Our results show that robustness claims based on a single behavioral or representational metric can be misleading, and motivate multi-level evaluation of how perturbations alter language-model computation.</div>
</div>

<div class='paper_details paper_details_withimg'>
  <div class='paper_title'>Last Translation Benchmark</div>
  <span class='authors_span'>Research project;&nbsp;&nbsp;&nbsp;Vilém Zouhar, Niyati Bafna, Mukund Choudhary, including Christian Hoang</span>
  <div style='margin-top: 5px;'><a href='https://arxiv.org/pdf/2609.04173' class='paper_details_link'>paper</a><a href='https://huggingface.co/datasets/zouhar/last-translation-benchmark' class='paper_details_link'>dataset</a><a href='https://last-translation-benchmark.vilda.net/' class='paper_details_link'>website</a><a href='https://github.com/zouharvi/last-translation-benchmark' class='paper_details_link'>code</a><a href='mailto:last-translation-benchmark@vilda.net' class='paper_details_link'>email</a></div>
  <img class='project_visual project_visual_ltb' src='img/favicon.svg' alt='Last Translation Benchmark project visual' loading='lazy'>
  <div style='margin-top: 5px;'><b>Abstract:</b> For scientific progress, we need benchmarks that test the limits of state-of-the-art models, and evaluation methods that inform us about failure cases. As models get stronger, standard benchmarks for machine translation are approaching saturation. Further, automatic translation metrics are unreliable, vulnerable to reward-hacking and provide unactionable assessments. Even gold human evaluation is not problem-free, because it often lacks reproducibility, objectivity, and scalability. Overall, this prevents us from tracking objective progress in the field and identifying pathways for improvement. We introduce the Last Translation Benchmark, a collection of human-authored and peer-reviewed examples (texts, images, audio, videos) that break leading machine translation models. We also present a new evaluation approach: each example comes with handcrafted verification rules describing concrete failure cases on that example, therefore allowing reliable and actionable future evaluation. The Last Translation Benchmark is a live dataset that accepts ongoing contributions. The latest version is LTBv1, containing accepted contributions prior to September 1st 2026, with future releases planned as new data is continuously collected.</div>
</div>

<div class='paper_details paper_details_withimg'>
  <div class='paper_title'>Meddies-PII: A Multilingual Framework for Personally Identifiable Information Extraction in Clinical De-identification</div>
  <span class='authors_span'>Paper coming soon;&nbsp;&nbsp;&nbsp;Le Linh Uyen, Christian Hoang, Ha Huy Hoang</span>
  <div style='margin-top: 5px;'><a href='https://arxiv.org/pdf/2609.12544' class='paper_details_link'>paper</a><a href='https://redact.meddies.ai/' class='paper_details_link'>demo</a><a href='https://huggingface.co/datasets/Meddies/meddies-pii' class='paper_details_link'>dataset</a><a href='https://huggingface.co/Meddies/meddies-pii' class='paper_details_link'>model</a></div>
  <img class='project_visual project_visual_meddies' src='img/project-meddies-pii.png' alt='Meddies-PII generation and verification pipeline' loading='lazy'>
  <div style='margin-top: 5px;'><b>Abstract:</b> Clinical de-identification depends on accurately identifying personally identifiable information (PII). However, manually annotated datasets are costly to build, and existing synthetic alternatives often provide limited generation details or use relatively simple synthesis strategies. We introduce Meddies-PII-Dataset, which contains one million synthetic clinical documents across seventeen languages and nine PII labels. Attribute-conditioned prompts generate the documents, and thirteen deterministic gates check their structural and annotation validity. To assess the dataset’s utility, we train Meddies-PII-Model, a BIOES token classifier. We compare it with existing PII extraction systems using exact-match entity-level F1. Meddies-PII-Model achieves the highest score among the evaluated systems on all reported benchmarks, with a mean F1 of 0.827 across fifteen external benchmarks compared with 0.658 for the strongest baseline. Upon acceptance, we will publicly release the dataset, benchmark, model, generation framework, and evaluation code to support research on multilingual clinical de-identification.</div>
</div>

'@

$css = (Invoke-WebRequest -Uri "$baseUrl/src/style.css?v=14" -UseBasicParsing).Content
$css += @'

.project_visual {
  width: 220px;
  height: 140px;
  object-fit: cover;
}

.project_visual_silvar {
  width: 350px;
  height: auto;
  max-width: 350px;
  max-height: none;
  margin-left: 10px;
}

.paper_details img.project_visual_silvar {
  width: 350px;
  height: auto;
  max-width: 350px;
  max-height: none;
  margin-bottom: 0;
}

.paper_details img.project_visual_perturbations {
  width: 350px;
  height: auto;
  max-width: 350px;
  max-height: none;
  margin-bottom: 0;
}

.paper_details img.project_visual_ltb {
  width: 220px;
  height: 140px;
  max-width: 220px;
  max-height: 140px;
  object-fit: contain;
  margin-bottom: 0;
}

.paper_details img.project_visual_meddies {
  width: 350px;
  height: auto;
  max-width: 350px;
  max-height: none;
  margin-bottom: 0;
}
'@
Save-TextFile -Path (Join-Path $root 'src/style.css') -Text $css

$router = @'
(function () {
  const allowedPages = ['about', 'research'];
  const queryPage = new URLSearchParams(window.location.search).get('page');
  const currentFile = window.location.pathname.split('/').pop() || 'index.html';

  if (queryPage && allowedPages.includes(queryPage) && (currentFile === 'index.html' || currentFile === '')) {
    window.location.replace(`${queryPage}.html`);
    return;
  }

  document.addEventListener('DOMContentLoaded', function () {
    const currentPage = currentFile.replace(/\.html$/, '') || 'about';
    document.querySelectorAll('#navmenu a').forEach(function (link) {
      const target = link.getAttribute('href').replace(/\.html$/, '');
      link.classList.toggle('active', target === currentPage);
    });
  });
})();
'@
Save-TextFile -Path (Join-Path $root 'src/router.js') -Text $router

$renderedPages = @{}
$researchContent = $researchContent.Replace('<b>Abstract:</b> ', '')
$researchContent = $researchContent.Replace('Research project;', 'Ongoing;').Replace('Paper coming soon;', 'Ongoing;')
$researchContent = $researchContent -replace 'Vil.{1,3}m Zouhar', 'Vil&eacute;m Zouhar'

$cardMarker = "<div class='paper_details paper_details_withimg'>"
$cardStarts = @()
$searchFrom = 0
while (($cardStart = $researchContent.IndexOf($cardMarker, $searchFrom)) -ge 0) {
  $cardStarts += $cardStart
  $searchFrom = $cardStart + $cardMarker.Length
}
if ($cardStarts.Count -eq 4) {
  $publicationHeading = $researchContent.Substring(0, $cardStarts[0])
  $publicationCards = @()
  for ($i = 0; $i -lt $cardStarts.Count; $i++) {
    $cardEnd = if ($i -lt ($cardStarts.Count - 1)) { $cardStarts[$i + 1] } else { $researchContent.Length }
    $publicationCards += $researchContent.Substring($cardStarts[$i], $cardEnd - $cardStarts[$i])
  }
  $researchContent = $publicationHeading + $publicationCards[3] + $publicationCards[2] + $publicationCards[1] + $publicationCards[0]
}
foreach ($page in $pages) {
  $html = (Invoke-WebRequest -Uri "$baseUrl/?page=$page" -UseBasicParsing).Content

  $html = [regex]::Replace($html, '<!-- Google tag \(gtag\.js\) -->[\s\S]*?</script>\s*<script>[\s\S]*?</script>', '')
  $html = [regex]::Replace($html, '<link\s+rel=["'']icon["''][^>]*>', "<link rel='icon' type='image/jpeg' href='src/avatar.jpg?v=2'>")
  $html = $html -replace 'src/style\.css\?v=14', 'src/style.css?v=19'
  $html = $html -replace 'src/portrait\.jpg\?v=1', 'src/portrait.jpg'
  $html = $html.Replace("src='src/portrait.jpg'", "src='src/avatar.jpg'")
  $html = $html.Replace("style='width: 201px; min-height: 268px; border: 2px solid black;'", "style='width: 201px; height: 201px; object-fit: cover; border: 2px solid black;'")
  $html = [regex]::Replace($html, '\s*<img src="src/icon\.svg"[\s\S]*?margin-top: 27px;">', '')
  $html = $html -replace 'Vil.m Zouhar is an PhD student', "$displayName is an PhD student"
  $html = $html -replace 'content="Vil.m Zouhar"', "content=`"$displayName`""
  $html = $html -replace '<title>Vil.m Zouhar</title>', "<title>$displayName</title>"
  $html = $html -replace 'alt=''photo of Vil.m''', "alt='avatar of $displayName'"
  $html = $html -replace 'Vil.m Zouhar\s*</h1>', "$displayName`n        </h1>"
  $html = $html -replace "Hi, I'm Vil.m \(colloquially Vilda\),", "Hi, I'm $displayName,"
  $html = $html.Replace('PhD at ETH Zurich<br>', 'BSc at FPT Ho Chi Minh<br>')
  $html = $html.Replace('Natural Language Processing<br>', 'Artificial Inteligence<br>')
  $html = $html.Replace('On the academic job market!', 'Open to collaboration')
  $html = $html.Replace('mailto:vzouhar@ethz.ch', 'mailto:christianhoang04@gmail.com')
  $html = $html.Replace('>vzouhar@ethz.ch<', '>christianhoang04@gmail.com<')
  $html = $html.Replace('https://scholar.google.com/citations?user=2EUDwtkAAAAJ', 'https://scholar.google.com/citations?user=mfm8-PkAAAAJ&hl=en')
  $html = $html -replace 'final-year PhD at ETH [^\.]+, Switzerland\.', 'final-year undergraduate at FPT University, Viet Nam.'
  $html = $html.Replace('I do research on natural language processing.', 'I do research on Artificial Intelligence.')
  $html = $html.Replace("Let me know if you're interested in any of these topics!", "Let me know if you're interested in any topic in the field!`n<p style='margin-top: 20px; font-style: italic;'>“My purpose is to contribute as much as I can to humanity.”</p>")
  $html = [regex]::Replace($html, '<ul style="margin-bottom: 5px;">\s*<li>Evaluation \(human annotations, automated metrics, methods\)</li>\s*<li>Multilingual NLP</li>\s*<li>NLP-oriented human-computer interaction \(confidence, quality\)</li>\s*</ul>', '')
  $html = $html -replace '\?page=(about|research)', '$1.html'
  $html = [regex]::Replace($html, '\s*<a href="(?:\?page=|)(?:teaching|service|typesetting)(?:\.html)?">(?:teaching|service|typesetting)</a>', '')
  if ($page -eq 'about') {
    $newsBlock = @'
<h4 style='margin-top: 60px;'>News</h4>
<ul>
    <li>09-2026: We are building the <a href="https://last-translation-benchmark.vilda.net/">Last Translation Benchmark</a> and looking for contributors! <a href="https://last-translation-benchmark.vilda.net/">Contribute samples</a> and become a contributor with coauthorship.</li>
    <li>09-2026: We are developing <a href="https://arxiv.org/pdf/2609.12544">Meddies-PII</a>, a multilingual framework for clinical personally identifiable information extraction.</li>
    <li>09-2026: We are studying how <a href="https://arxiv.org/pdf/2609.03322">perturbations propagate through large language models</a> across behavior, representations, and attention.</li>
    <li>11-2025: Our paper <a href="https://aclanthology.org/2025.emnlp-main.589.pdf">SilVar</a> was accepted to the EMNLP 2025 Main Conference. It presents speech-driven multimodal reasoning for visual question answering and object localization.</li>
</ul>
'@
    $html = [regex]::Replace($html, '<h4>News</h4>\s*<ul>[\s\S]*?</ul>', $newsBlock)
    $html = [regex]::Replace($html, '<h4>Experience</h4>[\s\S]*?(?=<h4>Awards</h4>)', '')
    $html = [regex]::Replace($html, '<h4>Awards</h4>[\s\S]*?(?=<h4>Links</h4>)', '')
    $contactBlock = @'
<h4>Contact</h4>
<ul>
    <li><a href="https://huggingface.co/christian-hoang-04">Hugging Face</a></li>
    <li><a href="https://github.com/christian-hoang-04">GitHub</a></li>
    <li><a href="https://scholar.google.com/citations?user=mfm8-PkAAAAJ&hl=en">Google Scholar</a></li>
</ul>
<p>Thanks to <a href="https://vilda.net/?page=about">Vil&eacute;m Zouhar</a> for inspiring the format of this website.</p>
'@
    $html = [regex]::Replace($html, '<h4>Links</h4>\s*<ul>[\s\S]*?</ul>', $contactBlock)
  }
  $html = [regex]::Replace($html, '<script>\s*document\.addEventListener\(''DOMContentLoaded''[\s\S]*?</script>', '')
  $html = $html -replace '</head>', "  <script src='src/router.js' defer></script>`n</head>"

  foreach ($posterUrl in $posterMap.Keys) {
    $posterPath = Join-Path $root ($posterMap[$posterUrl] -replace '/', [IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $posterPath)) {
      New-Item -ItemType Directory -Force -Path (Split-Path -Parent $posterPath) | Out-Null
      Invoke-WebRequest -Uri $posterUrl -UseBasicParsing -OutFile $posterPath
    }
    $html = $html.Replace($posterUrl, $posterMap[$posterUrl])
  }

  if ($page -eq 'research') {
    $contentStart = $html.IndexOf("<div id='content' style='margin-top: 20px;'>")
    $contentEnd = $html.IndexOf('</body>', $contentStart)
    if ($contentStart -lt 0 -or $contentEnd -lt 0) {
      throw 'Could not find the research content container.'
    }
    $prefix = $html.Substring(0, $contentStart)
    $suffix = $html.Substring($contentEnd)
    $html = $prefix + "<div id='content' style='margin-top: 20px;'>`n" + $researchContent + "`n    </div>`n" + $suffix
  }

  $html = [regex]::Replace($html, '<a(?<attrs>[^>]*\bhref\s*=\s*["''](?:https?://|mailto:)[^"'']+["''][^>]*)>', {
    param($match)
    if ($match.Groups['attrs'].Value -match '\btarget\s*=') {
      return $match.Value
    }
    return '<a' + $match.Groups['attrs'].Value + ' target="_blank" rel="noopener noreferrer">'
  })

  $renderedPages[$page] = $html

  [regex]::Matches($html, '(?:src|href)=["'']([^"'']+)["'']') | ForEach-Object {
    Download-Asset -RelativePath $_.Groups[1].Value
  }
}

foreach ($page in $pages) {
  Save-TextFile -Path (Join-Path $root "$page.html") -Text $renderedPages[$page]
}

foreach ($removedPage in @('teaching', 'service', 'typesetting')) {
  $removedPath = Join-Path $root "$removedPage.html"
  if (Test-Path -LiteralPath $removedPath) {
    Remove-Item -LiteralPath $removedPath -Force
  }
}

Save-TextFile -Path (Join-Path $root 'index.html') -Text $renderedPages['about']

Write-Output "Mirrored $($pages.Count) pages and local image assets into $root"
