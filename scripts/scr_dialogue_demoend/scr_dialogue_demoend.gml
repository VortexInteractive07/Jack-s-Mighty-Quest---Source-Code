//@description Used Script for the Demo Completion Screen's Dialogue
function msg_end(_speaker, _text) {
    return { speaker: _speaker, text: _text };
}

/// @function get_dialogue_demoend()
/// @description Returns the localized ending dialogue array based on global.language_mode
function get_dialogue_demoend() {
    // 0 = English, 1 = Romaji, 2 = Dhivehi (Latinized)
    switch (global.language_mode) {		
		 case 0: // English Mode
            return [
                msg_end("JACK", "Before we conclude with this tech demo, our author, and loving creator: Aayan, would like to have a formal word with you all:"),
                msg_end("", "Greetings! It has taken six arduous, unrelenting years to reach this defining milestone—a passage of time that often felt like an eternity with no end in sight."),
                msg_end("", "From my earliest origins crafting humble, hobbyist titles on an Android app using SilentWorks Game Creator—such as Kattafulhi the Hedgehog..."),
                msg_end("", "...all the way to engineering intricate, custom engine logic in GameMaker, this title, Jack's Mighty Quest, stands as the ultimate culmination of my personal evolution."),
                msg_end("", "Despite its unpolished edges, experimental systems, and remaining placeholder assets, this demo serves as raw, unmistakable proof of who I am and what I am truly capable of achieving."),
                msg_end("", "It is a profound privilege to watch a vision birthed in complete isolation finally breathe life, motion, and purpose upon the screen."),
                msg_end("", "Yet, as we step back to evaluate this accomplishment, we must confront an absolute truth: our time to execute our vision in this life is strictly finite."),
                msg_end("", "Consider this parallel: imagine yourself seated deep within an examination room, completely out of answers, staring blankly at a page in sheer, overwhelming perplexity."),
                msg_end("", "The wall clock ticks with cold, indifferent, and methodical precision—each rhythmic strike serving as a harsh reminder that precious seconds are slipping away, entirely beyond your control."),
                msg_end("", "In that tense, suffocating silence, you face a monumental choice: allow paralyzing anxiety to freeze you in place, or courageously seize your pen and forge your own answers before time expires completely."),
                msg_end("", "That ticking clock is reality itself. It does not pause for optimal conditions, superior hardware, perfect environments, or convenient circumstances."),
                msg_end("", "I am a developer who has fought entirely from the ground up without high-end equipment. I have spent years staring into frozen monitors, forcing legacy hardware to perform miracles through sheer willpower and logic."),
                msg_end("", "This path was never paved with gold or luxury. It demanded immense personal sacrifice, endless nights of blood, sweat, tears, and the unwavering support of my Discord community."),
                msg_end("", "Game development is a discipline of deep sacrifice, and sometimes those sacrifices leave permanent, unyielding scars."),
                msg_end("", "Half of this game's original soundtrack, composed by FN76, was stripped away entirely due to past friction, intense pressure, and harsh decisions."),
                msg_end("", "Yet, what remains in this build stays. No legal threats, DMCA notices, or personal fallout can halt or alter the inertia of what has already been put into motion."),
                msg_end("", "Every line of code we execute, every frame we optimize, and every pixel we place is our deliberate, unyielding stance against the quiet dark—a monument engineered before our time is called."),
                msg_end("", "This demo is not merely a collection of scripts and assets; it is the living manifestation of my core belief that an amateur can rise to become the absolute architect of their own universe."),
                msg_end("", "It stands as an immortal chronicle of the perseverance behind Vortex Interactive, InnovateSphere Studios, and DandiFIRE Productions."),
                msg_end("", "Thank you from the bottom of my heart for sharing this fleeting, pivotal moment with me, even when the path ahead seemed pitch black."),
                msg_end("", "I am Aayan. The quest… our quest… has only just begun.")
            ];
			
        case 1: // Romaji Mode
            return [
                msg_end("SYSTEM", "Kono demo wo musubu mae ni, ufehdhumi-nushi no Aayan kara,皆様 ni hitokoto go-aisatsu ga gozaimasu!"),
                msg_end("", "Roku-nen no tsurai hibi! Owaru koto no nai eien no you deshita!"),
                msg_end("", "Nisen-nijuu nen kara nisen-nijuu-roku nen made, honoo wa kiezu ni moe tsuzukete imasu."),
                msg_end("", "Korona-ka no jidai ni Kattafulhi the Hedgehog no you na hen na geeemu wo tsukutteita koro kara..."),
                msg_end("", "...kono Jack's Mighty Quest ni itaru made, yume wo jitsugen suru tame no jikan deshita!"),
                msg_end("", "Hora, eien na mono nante nai ndesu!"),
                msg_end("", "Subete no mono ni wa kagiri ga ari, watashitachi ya kono uchu ni sae mo owari no toki ga arimasu!"),
                msg_end("", "Geeemu mo koodo mo, kurai yami no naka de hakanaku kieyuku kinenhi ni sugimasen."),
                msg_end("", "Daga kagiri ga aru kara koso, watashitachi wa tsukuri, tatakai, nani ka wo nokosou to suru ndesu."),
                msg_end("", "Kono michi wa kesshite raku dewa nakatta. Chi to ase to namida, soshite Discord no nakama no tasuke de koko made komashita."),
                msg_end("", "Hakkiri iimasu. Watashi wa mazushii geeemu kaihatsu-sha desu. Juubun na kibai ga arimasen."),
                msg_end("", "Kogoeru gamen wo mitsume, furui PC de kiseki wo okoshite kita. Sore demo, yume wa kowasemasen!"),
                msg_end("", "Kaihatsu wa gisei ga tomonau. Soshite sono gisei wa shoujou wo nokoshimasu."),
                msg_end("", "FN76 ga sakkyoku shita kono geeemu no soundtrack no hanbun wa subete ushinawaremashita."),
                msg_end("", "Kanojo wa tensai deshita. Daga watashi no ikari to futashika na handan no sei de kanojo wo oitsumeta."),
                msg_end("", "Kanojo wa juusan-sai deshita. Kanojo wa JMQ kara kyoku wo tsubete mochisarimashita."),
                msg_end("", "Moshi kanojo ga kore wo kiiteiru nara: Watashi wa dou demo ii."),
                msg_end("", "Kyoku no ichibu wa demo ni nokorimasu. Sakujo wa shinai. DMCA wa watashi wo tomerarenai."),
                msg_end("", "Soshite, genjitsu ga gamen wo tsukinukeru. Genjitsu ga yondeiru."),
                msg_end("", "Kono kaihatsu no tochuu de sae, otouto ga shizukesa wo motome, interrupted shimashita. Kazoku ga saiyuusen desu."),
                msg_end("", "Konton no naka de shizukesa wo mitsukeru koto, sore ga zero kara geeemu wo tsukuru hontou no tatakai desu."),
                msg_end("", "Kono demo wa, amachua demo jibun no uchu wo tsukureru toiu shinji no akashi desu."),
                msg_end("", "Vortex Interactive, InnovateSphere, DandiFIRE no rekishi ga soko ni arimasu."),
                msg_end("", "Kurai michi de attemo, kono hakanai shunkan wo tomo ni shite kurete arigatou."),
                msg_end("", "Watashi wa Aayan desu. Bouken wa... mada hajimatta bakari desu.")
            ];

        case 2: // Dhivehi Mode (Latinized)
            return [
                msg_end("JACK", "Mi technical demo nimmunlaumuge kurin, mi masakkathuge musannifu adhi ahugadumen uffedhi faraai kamahvaa Aayan, thiyabeyfulhunnaa mukhaathabukoh baheh bunan beynunveyve:"),
                msg_end("", "Assalaamu'alaikum! Mi muhimmu ladhudhadiaa hama'ah vaasiluvumattaakai, bura adhi medhukedumeh neiy haha aharuge dhigu dhathureh ahugadu koffeeme. Mi heyhdhavi vaguthakee nimumen neiy fadha dhigu zamaanthakehge gothugai ihusaas kurevunu dhuvasthakeke."),
                msg_end("", "Android application eh kamahvaa 'SilentWorks Game Creator' beynunkohgen 'Kattafulhi the Hedgehog' fadha aadhage kulhivaru thah uffedhumun feshigen..."),
                msg_end("", "...'GameMaker' medhuverikoh amilla fannee ukulhuthakaai engine logic thah farumaakurumah hama'ah kuri dhathurugai, 'Jack's Mighty Quest' akee ahugaduge amilla kurierumaai hunaruge emme furihama natheeja'eve."),
                msg_end("", "Mi demogai adhi furihama nuvaa baithakaai, ajumabellumuge maruhalaagai vaa nizaamuthakaai, badhalu kuran jehey baheh vasiylaiy thah huri namaves, mee ahugadakee kaaku kan adhi ahugadah haasilu kureveyne kankamuge dhihi heki libidhey kameke."),
                msg_end("", "Ekaharikaigai hure dhekunu huvafeneh, miadhu mi screen-un dharigen ais, harakaaiyve, maqsadheh haasilu kurathan fenumakee ahugadah libey nuhanu bodi sharafehve."),
                msg_end("", "Ehen-namaves, mi kaamiyaabee aa medhu fhunkoh visnaalaairu, ahugadumen qaboolu kuran jehey haqeeqatheh eba'oiyve. E'ee mi dhuniyegai ahugadumen-ge thasavvuruthah haqeeqathakah hedhumah libifai vaa vaguthakee vaki minvarakah kanda'elhifai vaa, madhu vaguthukolheh kameve."),
                msg_end("", "Misaalakah mi kamaamedhu visnaaladhahvaashe: thibaa imthihaanu holeh-gai, kuraane ithuru kameh nethikee, hus karudhaas-gadakah balahattaigen hairankamegge thereygai inna manzaru sifa kolhvaashe."),
                msg_end("", "Faarugai harukohfai vaa gadeyge konme second-ehge adakee, thibaage baaruge dhashugai nuvaa, agu-huri vaguthuthah beykaaru vegen-dhaakan handhaan koh-dhey, hith-dhathi adhi harukashi inzaareke."),
                msg_end("", "E nuthanevas adhi haaskamun fureygen-vaa himeynkamuge thereygai, thibaage kurimatheygai othee bodi nimumeke: birugane, gaduvefai hunnaanee tho nuvatha hiyvaru-ekee galamugai hifai, vaguthu hamavumuge kurin amilla javaabuthah ufan-kuraanee tho'eve."),
                msg_end("", "E hingamundhaa gadeyakee aslu haqeeqatheve. Emme furihama haalatheh annandhen, nuvatha emme mathee fenvaruge aalaaiythakaai vasiylaiythah libendhen e gadeykah madheh nukureveyne'eve."),
                msg_end("", "Ahugadakee evves mathee fenvaruge vasiylathakaa nulaai, emme aadhage harufathun feshigen haguraama kuramun ai uffedhuntheri'akeeme. Baavefai vaa computer thakun fenvaru rangalhu masakkath_theh nerumattaakai, ethah ahareh vandhen hutthifai hunna monitor thakah balahattaigen, hiyvaraa fannee hunaruge beynun kohgen ahugadu masakkath_kureeme."),
                msg_end("", "Mi dhathurakee evves ireggai fasheyha nuvatha araamu dhathureh noon. Mee nuhanu bodi qurubaaneethakaai, nidhineiy ethah reythakaai, bura masakkathuge natheeja'eve. Adhi meege ithurun mee ahugaduge Discord community-in foaru-koh-dhin medhu-kedumeh-neiy eheetherikamuge natheejaaves meieve."),
                msg_end("", "Kulhivaru uffedhumuge mi dhaair'akee bodethi qurubaaneethakeh ekulevigen-vaa dhaair'akeve. Adhi baeh faharu e qurubaaneethakuge sababun dhaaimy nudhakadalaave fadha lakunuthakeh hithugai jehigen-dheyve."),
                msg_end("", "Mi kulhivaruge aslu music-ge dhebaikulha ehbai, music composer FN76 uffedhi namaves, kurin kurimathi-vi hamanujehunthakaai, bodi pressure-aa, adhi nimumunu harukashi nimmuthakuge sababun vanee unikuran jehifaeve."),
                msg_end("", "Ehen namaves, mihaaru mi uffedhumugai himeney ech_cheh dhen badhaleh nuvaane'eve. Evves qanoonee inzaarakah, copyright massala'akah, nuvatha amilla khiyaalu thafaathu-vumakah-ves, mihaaru feshifai vaa mi baarugadha dhathuru huttuvaieh nukureveyne'eve."),
                msg_end("", "Ahugadumen liyaa konme code-ehge folhuvathaa, furihama kura konme manzaraai, adhi kanda'alhaa konme pixel-akee-ves ahugadumen-ge vaguthu hamavumuge kurin, nugudaa azumaku-ekee binaa kura dhaaimy handhaany bina'eke."),
                msg_end("", "Mi demog'akee hama-ekani script-thakaai vasiylaiythakegge ekkurumeh nooneve. Mee amilla'ah kankan dhas-kuraa aadhage meehekah-ves, eynaage amilla dhuniyeyge furihama binaakuruntheri'akah vevidhaane-kan ahugadu kuraa varugadha ithubaaruge dhihiruhi misaaleke."),
                msg_end("", "Mee 'Vortex Interactive', 'InnovateSphere Studios' adhi 'DandiFIRE Productions' ge fahathugai vaa saabithukamundhaa keth therikamaai keth-therikan ramzu kohdhey, dhuvasakuves fanaa nuvaane thaareekhee heki libidhey bina'eke."),
                msg_end("", "Kurimatheygai oiy magu kithanme andhirikoh fenunu namaves, ahugaduge mi kuru adhi muhimmu vaguthukolhugai baivari-vevadaigathythee, ikhlaastherikamuaai eku hithuge emme funminun shukuru dhannavameve."),
                msg_end("", "Ahugadakee Aayan eve. Mi dhathuru... ahugadumen emmenge mi dhathuru... miee adhi feshumeke.")
            ];
    }
}