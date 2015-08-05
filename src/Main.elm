import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Set exposing (Set)
import Array exposing (Array)
import String
import List
import Json.Decode
import Result exposing (Result)
import Signal exposing (Address)
import Random exposing (Generator, Seed)
import Maybe exposing (Maybe (..))
import Char
import Keyboard

import Debug

import Native.Now


guessedLetter : Signal (Maybe Action)
guessedLetter = Signal.map (Char.fromCode >> (Guess >> Just)) Keyboard.presses


main : Signal Html
main =
  start { model = randomGame, view = view, update = update, actions = [guessedLetter]}


type alias App model action =
    { model : model
    , view : Address action -> model -> Html
    , update : action -> model -> model
    , actions : List (Signal (Maybe action))
    }


start : App model action -> Signal Html
start app =
  let
    actions =
      Signal.mailbox Nothing

    address =
      Signal.forwardTo actions.address Just

    model =
      Signal.foldp
        (\(Just action) model -> app.update action model)
        app.model
        (Signal.mergeMany (actions.signal :: app.actions))
  in
    Signal.map (app.view address) model


type alias Round =
  { word : String
  , guesses : Set Char
  , maxGuesses : Int
  }

type alias Game =
  { round : Round
  , seed : Seed
  }

{-| WARNING: SIDE-EFFECTS -}
seed : Seed
seed =
  Random.initialSeed Native.Now.loadTime


words : Array String
words =
  Array.fromList ["able","aboard","about","afraid","against","aloud","already","also","always","among","amount","angel","anger","angry","animal","another","answer","anybody","anyhow","anyone","anything","anyway","anywhere","apart","apartment","apiece","appear","apple","apron","arise","arithmetic","armful","army","arose","around","arrange","arrive","arrived","arrow","artist","ashes","aside","asleep","attack","attend","attention","aunt","author","auto","automobile","autumn","avenue","awake","awaken","away","awful","awfully","awhile","babe","babies","back","background","backward","backwards","bacon","badge","badly","bake","baker","bakery","baking","ball","balloon","banana","band","bandage","bang","banjo","bank","banker","barber","bare","barefoot","barely","bark","barn","barrel","base","baseball","basement","basket","batch","bath","bathe","bathing","bathroom","bathtub","battle","battleship","beach","bead","beam","bean","bear","beard","beast","beat","beating","beautiful","beautify","beauty","became","because","become","becoming","bedbug","bedroom","bedspread","bedtime","beech","beef","beefsteak","beehive","been","beer","beet","before","began","beggar","begged","begin","beginning","begun","behave","behind","being","believe","bell","belong","below","belt","bench","bend","beneath","bent","berries","berry","beside","besides","best","better","between","bible","bicycle","bigger","bill","billboard","bind","bird","birth","birthday","biscuit","bite","biting","bitter","black","blackberry","blackbird","blackboard","blackness","blacksmith","blame","blank","blanket","blast","blaze","bleed","bless","blessing","blew","blind","blindfold","blinds","block","blood","bloom","blossom","blot","blow","blue","blueberry","bluebird","blush","board","boast","boat","bobwhite","bodies","body","boil","boiler","bold","bone","bonnet","book","bookcase","bookkeeper","boom","boot","born","borrow","boss","both","bother","bottle","bottom","bought","bounce","bowl","boxcar","boxer","boxes","boyhood","bracelet","brain","brake","bran","branch","brass","brave","bread","break","breakfast","breast","breath","breathe","breeze","brick","bride","bridge","bright","brightness","bring","broad","broadcast","broke","broken","brook","broom","brother","brought","brown","brush","bubble","bucket","buckle","buffalo","buggy","build","building","built","bulb","bull","bullet","bumblebee","bump","bunch","bundle","bunny","burn","burst","bury","bush","bushel","business","busy","butcher","butt","butter","buttercup","butterfly","buttermilk","butterscotch","button","buttonhole","buzz","cabbage","cabin","cabinet","cackle","cage","cake","calendar","calf","call","caller","calling","came","camel","camp","campfire","canal","canary","candle","candlestick","candy","cane","cannon","cannot","canoe","canyon","cape","capital","captain","card","cardboard","care","careful","careless","carelessness","carload","carpenter","carpet","carriage","carrot","carry","cart","carve","case","cash","cashier","castle","catbird","catch","catcher","caterpillar","catfish","catsup","cattle","caught","cause","cave","ceiling","cell","cellar","cent","center","cereal","certain","certainly","chain","chair","chalk","champion","chance","change","chap","charge","charm","chart","chase","chatter","cheap","cheat","check","checkers","cheek","cheer","cheese","cherry","chest","chew","chick","chicken","chief","child","childhood","children","chill","chilly","chimney","chin","china","chip","chipmunk","chocolate","choice","choose","chop","chorus","chose","chosen","christen","church","churn","cigarette","circle","circus","citizen","city","clang","clap","class","classmate","classroom","claw","clay","clean","cleaner","clear","clerk","clever","click","cliff","climb","clip","cloak","clock","close","closet","cloth","clothes","clothing","cloud","cloudy","clover","clown","club","cluck","clump","coach","coal","coast","coat","cobbler","cocoa","coconut","cocoon","codfish","coffee","coffeepot","coin","cold","collar","college","color","colored","colt","column","comb","come","comfort","comic","coming","company","compare","conductor","cone","connect","cook","cooked","cooking","cookie","cookies","cool","cooler","coop","copper","copy","cord","cork","corn","corner","correct","cost","cottage","cotton","couch","cough","could","count","counter","country","county","course","court","cousin","cover","coward","cowardly","cowboy","cozy","crab","crack","cracker","cradle","cramps","cranberry","crank","cranky","crash","crawl","crazy","cream","creamy","creek","creep","crept","cried","croak","crook","crooked","crop","cross","crossing","crow","crowd","crowded","crown","cruel","crumb","crumble","crush","crust","cries","cuff","cuff","cupboard","cupful","cure","curl","curly","curtain","curve","cushion","custard","customer","cute","cutting","daddy","daily","dairy","daisy","damage","dame","damp","dance","dancer","dancing","dandy","danger","dangerous","dare","dark","darkness","darling","darn","dart","dash","date","daughter","dawn","daybreak","daytime","dead","deaf","deal","dear","death","decide","deck","deed","deep","deer","defeat","defend","defense","delight","dentist","depend","deposit","describe","desert","deserve","desire","desk","destroy","devil","diamond","died","dies","difference","different","dime","dine","dinner","direct","direction","dirt","dirty","discover","dish","dislike","dismiss","ditch","dive","diver","divide","dock","doctor","does","doll","dollar","dolly","done","donkey","door","doorbell","doorknob","doorstep","dope","double","dough","dove","down","downstairs","downtown","dozen","drag","drain","drank","draw","drawer","draw","drawing","dream","dress","dresser","dressmaker","drew","dried","drift","drill","drink","drip","drive","driven","driver","drop","drove","drown","drowsy","drub","drum","drunk","duck","dull","dumb","dump","during","dust","dusty","duty","dwarf","dwell","dwelt","dying","each","eager","eagle","early","earn","earth","east","eastern","easy","eaten","edge","eight","eighteen","eighth","eighty","either","elbow","elder","eldest","electric","electricity","elephant","eleven","else","elsewhere","empty","ending","enemy","engine","engineer","enjoy","enough","enter","envelope","equal","erase","eraser","errand","escape","even","evening","ever","every","everybody","everyday","everyone","everything","everywhere","evil","exact","except","exchange","excited","exciting","excuse","exit","expect","explain","extra","eyebrow","fable","face","facing","fact","factory","fail","faint","fair","fairy","faith","fake","fall","false","family","fancy","faraway","fare","farmer","farm","farming","farther","fashion","fast","fasten","father","fault","favor","favorite","fear","feast","feather","feed","feel","feet","fell","fellow","felt","fence","fever","fiddle","field","fife","fifteen","fifth","fifty","fight","figure","file","fill","film","finally","find","fine","finger","finish","fire","firearm","firecracker","fireplace","fireworks","firing","first","fish","fisherman","fist","fits","five","flag","flake","flame","flap","flash","flashlight","flat","flea","flesh","flew","flies","flight","flip","float","flock","flood","floor","flop","flour","flow","flower","flowery","flutter","foam","foggy","fold","folks","follow","following","fond","food","fool","foolish","foot","football","footprint","forehead","forest","forget","forgive","forgot","forgotten","fork","form","fort","forth","fortune","forty","forward","fought","found","fountain","four","fourteen","fourth","frame","free","freedom","freeze","freight","fresh","fret","fried","friend","friendly","friendship","frighten","frog","from","front","frost","frown","froze","fruit","fudge","fuel","full","fully","funny","furniture","further","fuzzy","gain","gallon","gallop","game","gang","garage","garbage","garden","gasoline","gate","gather","gave","gear","geese","general","gentle","gentleman","gentlemen","geography","getting","giant","gift","gingerbread","girl","give","given","giving","glad","gladly","glance","glass","glasses","gleam","glide","glory","glove","glow","glue","going","goes","goal","goat","gobble","godmother","gold","golden","goldfish","golf","gone","good","goods","goodbye","goodbye","goodness","goody","goose","gooseberry","govern","government","gown","grab","gracious","grade","grain","grand","grandchild","grandchildren","granddaughter","grandfather","grandma","grandmother","grandpa","grandson","grandstand","grape","grapes","grapefruit","grass","grasshopper","grateful","grave","gravel","graveyard","gravy","gray","graze","grease","great","green","greet","grew","grind","groan","grocery","ground","group","grove","grow","guard","guess","guest","guide","gulf","gunpowder","habit","hail","hair","haircut","hairpin","half","hall","halt","hammer","hand","handful","handkerchief","handle","handwriting","hang","happen","happily","happiness","happy","harbor","hard","hardly","hardship","hardware","hare","hark","harm","harness","harp","harvest","haste","hasten","hasty","hatch","hatchet","hate","haul","have","having","hawk","hayfield","haystack","head","headache","heal","health","healthy","heap","hear","hearing","heard","heart","heat","heater","heaven","heavy","heel","height","held","hell","hello","helmet","help","helper","helpful","henhouse","hers","herd","here","hero","herself","hickory","hidden","hide","high","highway","hill","hillside","hilltop","hilly","himself","hind","hint","hire","hiss","history","hitch","hive","hold","holder","hole","holiday","hollow","holy","home","homely","homesick","honest","honey","honeybee","honeymoon","honk","honor","hood","hoof","hook","hoop","hope","hopeful","hopeless","horn","horse","horseback","horseshoe","hose","hospital","host","hotel","hound","hour","house","housetop","housewife","housework","however","howl","huge","humble","hump","hundred","hung","hunger","hungry","hunk","hunt","hunter","hurrah","hurried","hurry","hurt","husband","hush","hymn","idea","ideal","important","impossible","improve","inch","inches","income","indeed","indoors","insect","inside","instant","instead","insult","intend","interested","interesting","into","invite","iron","island","itself","ivory","jacket","jacks","jail","jelly","jellyfish","jerk","jockey","join","joke","joking","jolly","journey","joyful","joyous","judge","juice","juicy","jump","junior","junk","just","keen","keep","kept","kettle","kick","kill","killed","kind","kindly","kindness","king","kingdom","kiss","kitchen","kite","kitten","kitty","knee","kneel","knew","knife","knit","knives","knob","knock","knot","know","known","lace","ladder","ladies","lady","laid","lake","lamb","lame","lamp","land","lane","language","lantern","lard","large","lash","lass","last","late","laugh","laundry","lawn","lawyer","lazy","lead","leader","leaf","leak","lean","leap","learn","learned","least","leather","leave","leaving","left","lemon","lemonade","lend","length","less","lesson","letter","letting","lettuce","level","liberty","library","lice","lick","life","lift","light","lightness","lightning","like","likely","liking","lily","limb","lime","limp","line","linen","lion","list","listen","little","live","lives","lively","liver","living","lizard","load","loaf","loan","loaves","lock","locomotive","lone","lonely","lonesome","long","look","lookout","loop","loose","lord","lose","loser","loss","lost","loud","love","lovely","lover","luck","lucky","lumber","lump","lunch","lying","machine","machinery","made","magazine","magic","maid","mail","mailbox","mailman","major","make","making","male","mama","mamma","manager","mane","manger","many","maple","marble","march","mare","mark","market","marriage","married","marry","mask","mast","master","match","matter","mattress","maybe","mayor","maypole","meadow","meal","mean","means","meant","measure","meat","medicine","meet","meeting","melt","member","mend","meow","merry","mess","message","metal","mice","middle","midnight","might","mighty","mile","milk","milkman","mill","miler","million","mind","mine","miner","mint","minute","mirror","mischief","miss","misspell","mistake","misty","mitt","mitten","moment","money","monkey","month","moon","moonlight","moose","more","morning","morrow","moss","most","mostly","mother","motor","mount","mountain","mouse","mouth","move","movie","movies","moving","much","muddy","mule","multiply","murder","music","must","myself","nail","name","napkin","narrow","nasty","naughty","navy","near","nearby","nearly","neat","neck","necktie","need","needle","neighbor","neighborhood","neither","nerve","nest","never","nevermore","news","newspaper","next","nibble","nice","nickel","night","nightgown","nine","nineteen","ninety","nobody","noise","noisy","none","noon","north","northern","nose","note","nothing","notice","nowhere","number","nurse","oatmeal","oats","obey","ocean","offer","office","officer","often","once","onion","only","onward","open","orange","orchard","order","organ","other","otherwise","ouch","ought","ours","ourselves","outdoors","outfit","outlaw","outline","outside","outward","oven","over","overalls","overcoat","overeat","overhead","overhear","overnight","overturn","owing","owner","pace","pack","package","page","paid","pail","pain","painful","paint","painter","painting","pair","palace","pale","pancake","pane","pansy","pants","papa","paper","parade","pardon","parent","park","part","partly","partner","party","pass","passenger","past","paste","pasture","patch","path","patter","pave","pavement","payment","peas","peace","peaceful","peach","peaches","peak","peanut","pear","pearl","peck","peek","peel","peep","pencil","penny","people","pepper","peppermint","perfume","perhaps","person","phone","piano","pick","pickle","picnic","picture","piece","pigeon","piggy","pile","pill","pillow","pine","pineapple","pink","pint","pipe","pistol","pitch","pitcher","pity","place","plain","plan","plane","plant","plate","platform","platter","play","player","playground","playhouse","playmate","plaything","pleasant","please","pleasure","plenty","plow","plug","plum","pocket","pocketbook","poem","point","poison","poke","pole","police","policeman","polish","polite","pond","ponies","pony","pool","poor","popcorn","popped","porch","pork","possible","post","postage","postman","potato","potatoes","pound","pour","powder","power","powerful","praise","pray","prayer","prepare","present","pretty","price","prick","prince","princess","print","prison","prize","promise","proper","protect","proud","prove","prune","public","puddle","puff","pull","pump","pumpkin","punch","punish","pupil","puppy","pure","purple","purse","push","puss","pussy","pussycat","putting","puzzle","quack","quart","quarter","queen","queer","question","quick","quickly","quiet","quilt","quit","quite","rabbit","race","rack","radio","radish","rail","railroad","railway","rain","rainy","rainbow","raise","raisin","rake","ranch","rang","rapidly","rate","rather","rattle","reach","read","reader","reading","ready","real","really","reap","rear","reason","rebuild","receive","recess","record","redbird","redbreast","refuse","reindeer","rejoice","remain","remember","remind","remove","rent","repair","repay","repeat","report","rest","return","review","reward","ribbon","rice","rich","riddle","ride","rider","riding","right","ring","ripe","rise","rising","river","road","roadside","roar","roast","robber","robe","robin","rock","rocky","rocket","rode","roll","roller","roof","room","rooster","root","rope","rose","rosebud","rotten","rough","round","route","rowboat","royal","rubbed","rubber","rubbish","rule","ruler","rumble","rung","runner","running","rush","rust","rusty","sack","saddle","sadness","safe","safety","said","sail","sailboat","sailor","saint","salad","sale","salt","same","sand","sandy","sandwich","sang","sank","sash","satin","satisfactory","sausage","savage","save","savings","scab","scales","scare","scarf","school","schoolboy","schoolhouse","schoolmaster","schoolroom","scorch","score","scrap","scrape","scratch","scream","screen","screw","scrub","seal","seam","search","season","seat","second","secret","seeing","seed","seek","seem","seen","seesaw","select","self","selfish","sell","send","sense","sent","sentence","separate","servant","serve","service","setting","settle","settlement","seven","seventeen","seventh","seventy","several","shade","shadow","shady","shake","shaker","shaking","shall","shame","shape","share","sharp","shave","shear","shears","shed","sheep","sheet","shelf","shell","shepherd","shine","shining","shiny","ship","shirt","shock","shoe","shoemaker","shone","shook","shoot","shop","shopping","shore","short","shot","should","shoulder","shout","shovel","show","shower","shut","sick","sickness","side","sidewalk","sideways","sigh","sight","sign","silence","silent","silk","sill","silly","silver","simple","since","sing","singer","single","sink","sissy","sister","sitting","sixteen","sixth","sixty","size","skate","skater","skin","skip","skirt","slam","slap","slate","slave","sled","sleep","sleepy","sleeve","sleigh","slept","slice","slid","slide","sling","slip","slipped","slipper","slippery","slit","slow","slowly","smack","small","smart","smell","smile","smoke","smooth","snail","snake","snap","snapping","sneeze","snow","snowy","snowball","snowflake","snuff","snug","soak","soap","socks","soda","sofa","soft","soil","sold","soldier","sole","some","somebody","somehow","someone","something","sometime","sometimes","somewhere","song","soon","sore","sorrow","sorry","sort","soul","sound","soup","sour","south","southern","space","spade","spank","sparrow","speak","speaker","spear","speech","speed","spell","spelling","spend","spent","spider","spike","spill","spin","spinach","spirit","spit","splash","spoil","spoke","spook","spoon","sport","spot","spread","spring","springtime","sprinkle","square","squash","squeak","squeeze","squirrel","stable","stack","stage","stair","stall","stamp","stand","star","stare","start","starve","state","station","stay","steak","steal","steam","steamboat","steamer","steel","steep","steeple","steer","stem","step","stepping","stick","sticky","stiff","still","stillness","sting","stir","stitch","stock","stocking","stole","stone","stood","stool","stoop","stop","stopped","stopping","store","stork","stories","storm","stormy","story","stove","straight","strange","stranger","strap","straw","strawberry","stream","street","stretch","string","strip","stripes","strong","stuck","study","stuff","stump","stung","subject","such","suck","sudden","suffer","sugar","suit","summer","sunflower","sung","sunk","sunlight","sunny","sunrise","sunset","sunshine","supper","suppose","sure","surely","surface","surprise","swallow","swam","swamp","swan","swat","swear","sweat","sweater","sweep","sweet","sweetness","sweetheart","swell","swept","swift","swim","swimming","swing","switch","sword","swore","table","tablecloth","tablespoon","tablet","tack","tail","tailor","take","taken","taking","tale","talk","talker","tall","tame","tank","tape","tardy","task","taste","taught","teach","teacher","team","tear","tease","teaspoon","teeth","telephone","tell","temper","tennis","tent","term","terrible","test","than","thank","thanks","thankful","that","theater","thee","their","them","then","there","these","they","thick","thief","thimble","thin","thing","think","third","thirsty","thirteen","thirty","this","thorn","those","though","thought","thousand","thread","three","threw","throat","throne","through","throw","thrown","thumb","thunder","tick","ticket","tickle","tiger","tight","till","time","tinkle","tiny","tiptoe","tire","tired","title","toad","toadstool","toast","tobacco","today","together","toilet","told","tomato","tomorrow","tone","tongue","tonight","took","tool","toot","tooth","toothbrush","toothpick","tore","torn","toss","touch","toward","towards","towel","tower","town","trace","track","trade","train","tramp","trap","tray","treasure","treat","tree","trick","tricycle","tried","trim","trip","trolley","trouble","truck","true","truly","trunk","trust","truth","tulip","tumble","tune","tunnel","turkey","turn","turtle","twelve","twenty","twice","twig","twin","ugly","umbrella","uncle","under","understand","underwear","undress","unfair","unfinished","unfold","unfriendly","unhappy","unhurt","uniform","unkind","unknown","unless","unpleasant","until","unwilling","upon","upper","upset","upside","upstairs","uptown","upward","used","useful","valentine","valley","valuable","value","vase","vegetable","velvet","very","vessel","victory","view","village","vine","violet","visit","visitor","voice","vote","wagon","waist","wait","wake","waken","walk","wall","walnut","want","warm","warn","wash","washer","washtub","waste","watch","watchman","water","watermelon","waterproof","wave","wayside","weak","weakness","weaken","wealth","weapon","wear","weary","weather","weave","wedding","weed","week","weep","weigh","welcome","well","went","were","west","western","whale","what","wheat","wheel","when","whenever","where","which","while","whip","whipped","whirl","whisky","whiskey","whisper","whistle","white","whole","whom","whose","wicked","wide","wife","wiggle","wild","wildcat","will","willing","willow","wind","windy","windmill","window","wine","wing","wink","winner","winter","wipe","wire","wise","wish","witch","with","without","woke","wolf","woman","women","wonder","wonderful","wood","wooden","woodpecker","woods","wool","woolen","word","wore","work","worker","workman","world","worm","worn","worry","worse","worst","worth","would","wound","wove","wrap","wrapped","wreck","wren","wring","write","writing","written","wrong","wrote","wrung","yard","yarn","year","yell","yellow","yesterday","yolk","yonder","young","youngster","your","yours","yourself","yourselves","youth"]


defaultWord : String
defaultWord = "hello"


randomGame : Game
randomGame =
  Random.generate game' seed
  |> fst


game' : Generator Game
game' =
  Random.customGenerator <| (\seed ->
    let
      (round, seed') = Random.generate round' seed
    in
      ({ round = round, seed = seed'}, seed')

  )


round' : Generator Round
round' =
  let
    wordsCount =
      Array.length words - 1

    index =
      Random.int 0 wordsCount
  in
    Random.customGenerator <| (\seed ->
      let
        (i, seed') =
          Random.generate index seed

        word =
          Array.get i words
          |> Maybe.withDefault defaultWord

      in
        (round word, seed')
    )


round : String -> Round
round word =
  { word = word
  , guesses = Set.empty
  , maxGuesses = 5
  }


type Action
  = Guess Char
  | Reset


update : Action -> Game -> Game
update action game =
  case action of
    Guess char ->
      let
        model = game.round

        newGuesses =
          if  | Char.isLower char -> Set.insert char model.guesses
              | Char.isUpper char -> Set.insert (Char.toLower char) model.guesses
              | otherwise -> model.guesses

        updatedRound =
          { model | guesses <- newGuesses }
      in
        { game | round <- updatedRound }

    Reset ->
      let
        (newRound, seed') = Random.generate round' game.seed

      in
        { round = newRound, seed = seed' }


view : Signal.Address Action -> Game -> Html
view address game =
  let
    model = game.round

    wordChars =
      String.toLower model.word
      |> String.toList
      |> Set.fromList

    correctGuess letter =
      Set.member letter wordChars

    (hits, misses) =
      Set.partition correctGuess model.guesses

    mask letter =
      if | Set.member letter hits -> letter
         | otherwise -> '*'

    maskedWord =
      String.map mask model.word

    resetButton =
      button
        [ onClick address Reset ]
        [ text "Reset" ]

    playingView =
      div
        []
        [ div [] [ text ("Word: " ++ maskedWord) ]
        , div [] [ text ("Misses: " ++ (toString misses)) ]
        , resetButton
        ]

    wonView =
      div []
        [ text ("You won! The word was: " ++ model.word)
        , resetButton
        ]

    lostView =
      div []
        [ text ("You lost! The word was: " ++ model.word)
        , resetButton
        ]

    won =
      wordChars `eq` model.guesses

    lost =
      not won && (Set.toList misses |> List.length) >= model.maxGuesses
  in
    if  | won -> wonView
        | lost -> lostView
        | otherwise -> playingView


eq : Set comparable -> Set comparable -> Bool
eq a b =
  Set.diff a b
  |> Set.isEmpty

onEnter : Address a -> a -> Attribute
onEnter address value =
  on "keydown"
    (Json.Decode.customDecoder keyCode is13)
    (\_ -> Signal.message address value)


is13 : Int -> Result String ()
is13 code =
  if code == 13 then Ok () else Err "not the right key code"

