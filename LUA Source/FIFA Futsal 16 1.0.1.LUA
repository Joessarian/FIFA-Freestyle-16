
-- GLOBALS --

-- If start address for slider-change code block allocated in memory.
allocated = false;

-- Hotkeys
enableHK = nil;
attachHK = nil;
wallsHK = nil;
streetUIHK = nil;

-- Width of current resolution in pixels
resolutionWidth = getAddressList().getMemoryRecordByDescription("ResolutionWidth");

--Ball Position
ballYPos = getAddressList().getMemoryRecordByDescription("BallYPos");
ballXPos = getAddressList().getMemoryRecordByDescription("BallXPos");
ballZPos = getAddressList().getMemoryRecordByDescription("BallZPos");
prevYP = 1;
prevXP = 1;

-- distance from center of field at which players are frozen
freezeDist = 500;

-- Ball Momentum
ballYM = getAddressList().getMemoryRecordByDescription("BallYM");
ballXM = getAddressList().getMemoryRecordByDescription("BallXM");
ballZM = getAddressList().getMemoryRecordByDescription("BallZM");
pYP = 1;
pXP = 1;
pZP = 1;
pYM = 1;
pXM = 1;
pZM = 1;

--Time after Kickoff in seconds
time = getAddressList().getMemoryRecordByDescription("Time");

--Player X Coordinates
homeLS = getAddressList().getMemoryRecordByDescription("HomeLS");
homeRS =  getAddressList().getMemoryRecordByDescription("HomeRS");
homeLM =  getAddressList().getMemoryRecordByDescription("HomeLM");
homeLCM =  getAddressList().getMemoryRecordByDescription("HomeLCM");
homeRCM =  getAddressList().getMemoryRecordByDescription("HomeRCM");
homeRM =  getAddressList().getMemoryRecordByDescription("HomeRM");
homeLB =  getAddressList().getMemoryRecordByDescription("HomeLB");
homeLCB =  getAddressList().getMemoryRecordByDescription("HomeLCB");
homeRCB =  getAddressList().getMemoryRecordByDescription("HomeRCB");
homeRB =  getAddressList().getMemoryRecordByDescription("HomeRB");
homeGK =  getAddressList().getMemoryRecordByDescription("HomeGK");

awayLS = getAddressList().getMemoryRecordByDescription("AwayLS");
awayRS =  getAddressList().getMemoryRecordByDescription("AwayRS");
awayLM =  getAddressList().getMemoryRecordByDescription("AwayLM");
awayLCM =  getAddressList().getMemoryRecordByDescription("AwayLCM");
awayRCM =  getAddressList().getMemoryRecordByDescription("AwayRCM");
awayRM =  getAddressList().getMemoryRecordByDescription("AwayRM");
awayLB =  getAddressList().getMemoryRecordByDescription("AwayLB");
awayLCB =  getAddressList().getMemoryRecordByDescription("AwayLCB");
awayRCB =  getAddressList().getMemoryRecordByDescription("AwayRCB");
awayRB =  getAddressList().getMemoryRecordByDescription("AwayRB");
awayGK =  getAddressList().getMemoryRecordByDescription("AwayGK");

-- Array of player coordinates
playersArray =
{
[1]={["pos"]=homeLM, ["ID"]=8, ["onField"]=true},
[2]={["pos"]=awayLM, ["ID"]=26, ["onField"]=true},
[3]={["pos"]=homeRM, ["ID"]=5, ["onField"]=true},
[4]={["pos"]=awayRM, ["ID"]=23, ["onField"]=true},
[5]={["pos"]=homeLB, ["ID"]=4, ["onField"]=true},
[6]={["pos"]=awayLB, ["ID"]=22, ["onField"]=true},
[7]={["pos"]=homeRB, ["ID"]=1, ["onField"]=true},
[8]={["pos"]=awayRB, ["ID"]=19, ["onField"]=true},
[9]={["pos"]=homeLCM, ["ID"]=7, ["onField"]=true},
[10]={["pos"]=awayLCM, ["ID"]=25, ["onField"]=true},
[11]={["pos"]=homeRCM, ["ID"]=6, ["onField"]=true},
[12]={["pos"]=awayRCM, ["ID"]=24, ["onField"]=true},
[13]={["pos"]=homeRCB, ["ID"]=2, ["onField"]=true},
[14]={["pos"]=awayRCB, ["ID"]=20, ["onField"]=true},
[15]={["pos"]=homeLCB, ["ID"]=3, ["onField"]=true},
[16]={["pos"]=awayLCB, ["ID"]=21, ["onField"]=true},
[17]={["pos"]=homeRS, ["ID"]=9, ["onField"]=true},
[18]={["pos"]=awayRS, ["ID"]=27, ["onField"]=true},
[19]={["pos"]=homeLS, ["ID"]=10, ["onField"]=true},
[20]={["pos"]=awayLS, ["ID"]=28, ["onField"]=true},
[21]={["pos"]=homeGK, ["ID"]=0, ["onField"]=true},
[22]={["pos"]=awayGK, ["ID"]=18, ["onField"]=true},
};

-- TODO
-- Cue to reposition players
reposition = getAddressList().getMemoryRecordByDescription("Reposition");

-- Whether or not a kickoff is occurring
kickoff = getAddressList().getMemoryRecordByDescription("Kickoff");

-- Multiplier that gives the proportion of remaining momentum following bounce.
mMult = 0.8;

-- Opening in barrier for goals' width
-- Defaults to futsal size: 250 units in DB
goalWidth = 5.14;

-- Opening in barrier for goals' height
-- Defaults to futsal size: 300 units in DB
goalHeight = 8.0;

-- Number of players per team
numPlayersPerTeam = 5;

-- Number of outfield players to remove
outfieldPlayers = numPlayersPerTeam

-- Goalie enabled
goalieEnabled = true;

-- Give game mode selection
gameMode = 0

-- [Last Man Standing Game Mode]
-- Gives the number of goals scored by each team
-- First team to five goals wins
homeGoals = getAddressList().getMemoryRecordByDescription("HomeGoals");
awayGoals = getAddressList().getMemoryRecordByDescription("AwayGoals");
-- Gives the ratio of in-game minutes to real-life minutes.
-- For example, a halflength of 4 minutes is 45 in-game minutes, so
-- the time scale will equal 45/4 = 11.25
timeScale = getAddressList().getMemoryRecordByDescription("TimeScale");
-- Set number of players per team to
-- smaller of two teams' player counts
minRemainingPlayers = 5;
-- Stores goal count of leading team
maxGoals = 0;
-- team goal counts for last man standing
hGoalsCount = 0
aGoalsCount = 0
-- if a goal has been scored since last check
newGoal = false;
-- Current half-time
cTime = 0;

-- [Skill Battle Game Mode]
-- Skillmoves database (keys: ID num, values: {[1]=Name, [2]=Points}
skillmoveDB =
{
 [37]={[1]="Flick Up",[2]=20,[3]=1},
 [45]={[1]="Laces Flick Up",[2]=30,[3]=2},
 [44]={[1]="Ball Juggle",[2]=15,[3]=1},
 [4]={[1]="Standing Body Feint Right",[2]=10,[3]=1},
 [5]={[1]="Standing Body Feint Left",[2]=10,[3]=1},
 [85]={[1]="Standing Stepover Right",[2]=15,[3]=1},
 [86]={[1]="Standing Stepover Left",[2]=15,[3]=1},
 [8]={[1]="Body Feint Right",[2]=15,[3]=1},
 [9]={[1]="Body Feint Left",[2]=15,[3]=1},
 [3]={[1]="Stepover Right",[2]=20,[3]=1},
 [2]={[1]="Stepover Left",[2]=20,[3]=1},
 [13]={[1]="Exit 90 Right",[2]=25,[3]=1},
 [10]={[1]="Exit 90 Left",[2]=25,[3]=1},
 [12]={[1]="Exit 45 Right",[2]=25,[3]=1},
 [11]={[1]="Exit 45 Left",[2]=25,[3]=1},
 [14]={[1]="Exit 135 Right",[2]=25,[3]=1},
 [16]={[1]="Exit 135 Left",[2]=25,[3]=1},
 [15]={[1]="Exit 180",[2]=25,[3]=1},
 [69]={[1]="Reverse Stepover Right",[2]=25,[3]=1},
 [72]={[1]="Reverse Stepover Left",[2]=25,[3]=1},
 [77]={[1]="Ball Roll Right",[2]=20,[3]=1},
 [76]={[1]="Ball Roll Left",[2]=20,[3]=1},
 [58]={[1]="Drag Back",[2]=25,[3]=1},
 [65]={[1]="Scoop Up",[2]=45,[3]=2},
 [82]={[1]="Roulette Right",[2]=65,[3]=2},
 [83]={[1]="Roulette Left",[2]=65,[3]=2},
 [34]={[1]="Reverse Elastico",[2]=100,[3]=3},
 [35]={[1]="Elastico",[2]=100,[3]=3},
 [62]={[1]="Ball Hop",[2]=70,[3]=2},
 [63]={[1]="Heel To Heel Flick",[2]=55,[3]=2},
 [57]={[1]="Simple Rainbow Heel Scoop",[2]=40,[3]=2},
 [56]={[1]="Simple Rainbow",[2]=110,[3]=3},
 [52]={[1]="Advanced Rainbow Ball Roll",[2]=50,[3]=2},
 [51]={[1]="Advanced Rainbow",[2]=150,[3]=4},
 [88]={[1]="Standing Spin Right",[2]=75,[3]=2},
 [87]={[1]="Standing Spin Left",[2]=75,[3]=2},
 [81]={[1]="Spin Right",[2]=80,[3]=2},
 [80]={[1]="Spin Left",[2]=80,[3]=2},
 [74]={[1]="McGeady Spin Right",[2]=90,[3]=3},
 [75]={[1]="McGeady Spin Left",[2]=90,[3]=3},
 [140]={[1]="Ball Roll Chop",[2]=50,[3]=2},
 [136]={[1]="Ball Roll Cut Right",[2]=50,[3]=2},
 [137]={[1]="Ball Roll Cut Left",[2]=50,[3]=2},
 [141]={[1]="Quick Ball Rolls",[2]=50,[3]=2},
 [73]={[1]="Hocus Pocus",[2]=100,[3]=3},
 [36]={[1]="Triple Elastico",[2]=120,[3]=3},
 [79]={[1]="Ball Roll Flick Right",[2]=70,[3]=2},
 [78]={[1]="Ball Roll Flick Left",[2]=70,[3]=2},
 [84]={[1]="Sombrero Flick",[2]=175,[3]=4},
 [138]={[1]="Ball Roll Crossover Fake Right",[2]=90,[3]=3},
 [139]={[1]="Ball Roll Crossover Fake Left",[2]=90,[3]=3},
 [31]={[1]="Rabona Fake Right",[2]=75,[3]=2},
 [32]={[1]="Rabona Fake Left",[2]=75,[3]=2},
 [25]={[1]="Rabona Fake",[2]=75,[3]=2},
 [134]={[1]="Elastico Chop Right",[2]=80,[3]=2},
 [135]={[1]="Elastico Chop Left",[2]=80,[3]=2},
 [48]={[1]="Juggling Sombrero Right",[2]=200,[3]=4},
 [47]={[1]="Juggling Sombrero Left",[2]=200,[3]=4},
 [49]={[1]="Juggling Sombrero Overhead",[2]=250,[3]=4},
 [43]={[1]="ATW Clockwise",[2]=225,[3]=4},
 [41]={[1]="ATW Counterclockwise",[2]=225,[3]=4},
 [38]={[1]="Juggling Elastico",[2]=225,[3]=4},
 [50]={[1]="Volley Flick Up",[2]=150,[3]=4},
 ["57"]={[1]="Juggling Rainbow",[2]=300,[3]=4},
 ["77"]={[1]="Juggling Stepover Right",[2]=200,[3]=4},
 ["76"]={[1]="Juggling Stepover Left",[2]=200,[3]=4},
 [61]={[1]="Chest Flick",[2]=500,[3]=4},
 [21]={[1]="Scoop Turn Right",[2]=75,[3]=2},
 [22]={[1]="Scoop Turn Left",[2]=75,[3]=2},
 [33]={[1]="Flair Fake",[2]=50,[3]=2},
 [30]={[1]="Shot Fake",[2]=25,[3]=1},
 [59]={[1]="Drag Back Crossover Fake Right",[2]=100,[3]=3},
 [60]={[1]="Drag Back Crossover Fake Left",[2]=100,[3]=3},
 [17]={[1]="Drag Back And Go",[2]=50,[3]=2},
 [26]={[1]="Shot Fake",[2]=25,[3]=1},
 [24]={[1]="Shot Fake",[2]=25,[3]=1},
 [23]={[1]="Shot Fake",[2]=25,[3]=1},
 [20]={[1]="Shot Fake",[2]=25,[3]=1},
 [46]={[1]="Flick Up",[2]=20,[3]=1},
 [67]={[1]="Ball Roll Stepover Right",[2]=40,[3]=2},
 [68]={[1]="Ball Roll Stepover Right",[2]=40,[3]=2},
 [70]={[1]="Ball Roll Stepover Left",[2]=40,[3]=2},
 [71]={[1]="Ball Roll Stepover Left",[2]=40,[3]=2},
};

controlColorList =
{
 [1]=0x00FFFFFF;
 [2]=0x00FF00;
 [3]=0x00FFFF;
 [4]=0x00FF;
};
-- Scoreboard goal tallies
homeScore = getAddressList().getMemoryRecordByDescription("HomeScore");
awayScore = getAddressList().getMemoryRecordByDescription("AwayScore");
homeOG = getAddressList().getMemoryRecordByDescription("HomeOG");
awayOG = getAddressList().getMemoryRecordByDescription("HomeOG");
-- Constants:
-- num of points per skill pass, cross, shot
SKILLPASS_PTS = 100;
SKILLSHOT_PTS = 150;
BEAT_DEF_BASE_PTS = 100;
FORCED_TACKLE_MISS_PTS = 150;
GOAL_BASE_PTS = 1000;
NUTMEG_PTS = 500;

-- Multipliers for successful completion of sequence
-- (team possession or dribble possession)
GOAL_PTS_MULT = 2.5;
FANCY_GOAL_PTS_MULT = 10.0;
WALLPASS_MULT = 2.0;
RABONA_MULT = 1.5;
SCOOP_MULT = 1.25
FORCED_TACKLE_MISS_MULT = 2;

-- Temporary skillmove points counter
skillmovePts = 0;

-- Events
-- skillmove occurred
skillmoveOccurred = false;
-- cannot perform the same skill twice in quick succession
lastSkillmoveID = 0;
-- number of skills performed during dribble possession
dribblePossessionSkills = 0;
-- one is home; two is away.
teamInPossession = 1;
-- team defending
teamNotInPossession = math.abs(teamInPossession - 2) + 1;
-- nutmeg occurs (indicator value remains constant
-- for a few timer intervals, so a one-time boolean is needed
nutmegOccurs = false;
-- nutmeg passshot points accounted for
nutmegPtsAdded = false;
-- Number of beaten defenders calculated by the previous thread
totalDefendersBeaten = 0;
-- number of beaten defenders for current dribble
beatDefenders = 0;
-- Add temp points from dribble-beat to total
accumulateSkillBeatPts = false;
-- Ball bounces off wall
ballHitWall = false;
-- Ball may hit wall
potentialWallPass = false;
-- Goal occurs
isGoal = false;
-- Changed visibility of street ui
changedVisibility = false;
-- Has half ended
endedHalf = false;
-- Have the players been repositioned after oop sequence
repositioned = false;
-- Team the last balltouch was made by
-- used to accumulate nutmeg pts
lastTeamBallTouch = 1;
-- X position on field to place ball during half-end
xPos = 44;
-- New game started -- one time reset of variables
newGame = false;
-- setplay occurs
setplayStart = false;
-- time since start of freekick
-- if above a second, allow players to return to field
timeSinceFK = 0;
-- is a freekick
isFreeKick = false;
-- UI X Pos on screen
-- UI Y Pos on screen
xPosUI = 0;
yPosUI = 0;


-- Memory records
defendersBeaten = getAddressList().getMemoryRecordByDescription("DefendersBeaten");
nutmeg = getAddressList().getMemoryRecordByDescription("Nutmeg");
dribblePossession = getAddressList().getMemoryRecordByDescription("DribblePossession");
skillmoveID = getAddressList().getMemoryRecordByDescription("SkillmoveID");
skillmoveOccurs = getAddressList().getMemoryRecordByDescription("SkillmoveOccurs");
fancyPassShot = getAddressList().getMemoryRecordByDescription("FancyPassShot");
passCounter = getAddressList().getMemoryRecordByDescription("PassCounter");
shotCounter = getAddressList().getMemoryRecordByDescription("ShotCounter");
homeCompletedPasses = getAddressList().getMemoryRecordByDescription("HomeCompletedPasses");
awayCompletedPasses = getAddressList().getMemoryRecordByDescription("AwayCompletedPasses");
ballWillHitWall = getAddressList().getMemoryRecordByDescription("BallWillHitWall");
teamPossession = getAddressList().getMemoryRecordByDescription("TeamPossession");
ballTouchCounter = getAddressList().getMemoryRecordByDescription("BallTouchCounter");
tackleResult = getAddressList().getMemoryRecordByDescription("TackleResult");
tackleCounter = getAddressList().getMemoryRecordByDescription("TackleCounter");
skillmoveCounter = getAddressList().getMemoryRecordByDescription("SkillmoveCounter");
isInMenu = getAddressList().getMemoryRecordByDescription("IsInMenu");
halfLength = getAddressList().getMemoryRecordByDescription("HalfLength");
newGameStarted = getAddressList().getMemoryRecordByDescription("NewGameStarted");
addedTimeScale = getAddressList().getMemoryRecordByDescription("AddedTimeScale");
endOfHalf = getAddressList().getMemoryRecordByDescription("EndOfHalf");
teamBallTouch = getAddressList().getMemoryRecordByDescription("TeamBallTouch");
playerPossession = getAddressList().getMemoryRecordByDescription("PlayerPossession");
possessorID = getAddressList().getMemoryRecordByDescription("PossessorID");
freekickCounter = getAddressList().getMemoryRecordByDescription("FreekickCounter");

-- Counters
passCount = 0;
shotCount = 0;
ballTouchCount = 0;
tackleCount = 0;
skillmoveCount = 0;
fancyPassShotCount = 0;
-- Not the number of wallpasses but tied to
-- its calculation
wallPassCount = 0;
wallBallTouchCount = 0;
freekickCount = 0;

-- Fancy animations register
-- given by (k,v) = <name>, {<boolHasOccurred>, <skillPts>}
fancyAnimations = {
                   ["fancyPass"] = {[1]=false, [2]=100, [3]="Flair Pass"},
                   ["rabona"] = {[1]=false, [2]=150, [3]="Rabona"},
                   ["scoopPass"] = {[1]=false, [2]=125, [3]="Scoop Pass"},
                   ["fancyShot"] = {[1]=false, [2]=150, [3]="Flair Shot"}
                  };
-- Completed passes for each team
compPasses = {[1]=0, [2]=0}

-- Calculated after each sequence of play
skillPtsTotal = {[1]=0, [2]=0};

-- Goals for each team
goalsTotal = {[1]=0, [2]=0};

-- Timer for futsal barrier thread creation
wallTimer = createTimer(nil);
timer_setInterval(wallTimer, 5);
wallTimer.setEnabled(false);

-- Timer for removing players
removePlayersTimer = createTimer(nil);
timer_setInterval(removePlayersTimer, 100);
removePlayersTimer.setEnabled(false);

-- Hotkey checker
hkTimer = createTimer(nil);
timer_setInterval(hkTimer, 500);
hkTimer.setEnabled(false);

-- Attach timer
attachTimer = createTimer(nil);
timer_setInterval(attachTimer, 1000);
attachTimer.setEnabled(false);

-- Skill Battle calculations timer
skillBattleTimer = createTimer(nil);
timer_setInterval(skillBattleTimer, 50);
skillBattleTimer.setEnabled(false);

-- Checks if the mod is enabled
enabled = false

-- Attached to FIFA 18 process?
attached = false;

-- Futsal mode is enabled
gameReady = false;

-- Walls reset
wallCheck = false;

-- Load form with controls and
function createFormFunctionality()
         form_show(Main);
         form_hide(StreetUI);
         setProperty(Main, "ShowInTaskBar", "stAlways");
         setupStreetUI();

         StreetUI.OnClose = closeClick;
         Main.OnClose = closeConfigurator;
end

-- Destroy timers and close main window
function closeConfigurator()

         attachTimer.setEnabled(false);
         attachTimer.destroy();
         hkTimer.setEnabled(false);
         hkTimer.destroy();
         wallTimer.setEnabled(false);
         wallTimer.destroy();
         removePlayersTimer.setEnabled(false);
         removePlayersTimer.destroy();
         skillBattleTimer.setEnabled(false);
         skillBattleTimer.destroy();

         enableHK.destroy();
         attachHK.destroy();
         wallsHK.destroy();
         streetUIHK.destroy();

         deallocAndUnregister();
         collectgarbage("collect");
         closeCE();
end

-- Deallocate all labels and unregister symbols
function deallocAndUnregister()
         local dealloc =
         [[
            dealloc(skillmoveOccurs)
            dealloc(skillmoveID)
            dealloc(fancyPassShotOccurs)
            dealloc(fancyPassShot)
            dealloc(passCount)
            dealloc(ballTouch)
            dealloc(ballTouchCounter)
            dealloc(skillmoveCheck)
            dealloc(skillmoveCounter)
            dealloc(tackleCheck)
            dealloc(tackleResult)
            dealloc(tackleCount)
            dealloc(possession)
            dealloc(playerPossession)
            dealloc(fkCount)
            dealloc(fkCounter)
         ]]

         local unregister =
         [[
            unregistersymbol(skillmoveOccurs)
            unregistersymbol(skillmoveID)
            unregistersymbol(fancyPassShotOccurs)
            unregistersymbol(fancyPassShot)
            unregistersymbol(passCount)
            unregistersymbol(ballTouch)
            unregistersymbol(ballTouchCounter)
            unregistersymbol(skillmoveCheck)
            unregistersymbol(skillmoveCounter)
            unregistersymbol(tackleCheck)
            unregistersymbol(tackleResult)
            unregistersymbol(tackleCount)
            unregistersymbol(possession)
            unregistersymbol(playerPossession)
            unregistersymbol(fkCount)
            unregistersymbol(fkCounter)
         ]]

         autoAssemble(dealloc);
         autoAssemble(unregister);

end

-- Check to see if the opened process (if any) is FIFA 18
function openFIFAProcess()
  pID = getProcessIDFromProcessName("fifa16.exe");
  -- print(pID);

  if (pID ~= nil) then
     -- disable all post-enable timers to prevent glitches upon restarting FIFA and re-attaching
     -- re-enable if re-attaching
     enabled = true;

     openProcess(pID);
     attached = true;
     Main_AttachButton.setCaption("Re-attach");
     attachTimer.setEnabled(false);
     enableMod();

  else
      attached = false;
      Main_AttachButton.setCaption("Attach");
  end
end

-- Set up mode settings and begin checks
function enableMod()

           if not (enabled) then
              Main_EnableModToggleBox.setCaption("Disable FIFA Street 16");
              Main_OptionsPanel.Color = 0x008800;
              enabled = true;
              chooseGameMode(Main);
              chooseGoalSize(Main);
              getNumPlayers(Main);
              enableGoalie(Main);
              if (attached) then
                 enableWalls(Main);
                 setupSkillBattle();
                 addedTimeScale.setValue(60.0);
                 timeScale.setValue(45/tonumber(halfLength.getValue()));
              end
              removePlayersTimer.setEnabled(true);
              timer_onTimer(removePlayersTimer, removePlayers);
              if (gameMode == 2 or Main_StreetUIToggleBox.getState() == 1) then
                 xPosUI = resolutionWidth.getValue()/2 - StreetUI.Width/2;
                 yPosUI = math.floor(35*(resolutionWidth.getValue())/2560);
                 skillBattleTimer.setEnabled(true);
                 timer_onTimer(skillBattleTimer, skillScoreKeeper);
              end
           else
               Main_EnableModToggleBox.setCaption("Enable FIFA Street 16");
               Main_OptionsPanel.Color = 0x88;
               enabled = false;
               wallTimer.setEnabled(false);
               removePlayersTimer.setEnabled(false);
               skillBattleTimer.setEnabled(false);
           end

end

-- Choose the game mode:
-- 0~ Regular (5v5, ..., 1v1 with goalie)
-- 1~ No GK (5v5, ..., 1v1)
-- 2~ GK only (1v1 only, glitchy)
-- 3~ Last Man Standing (5v5 only, WIP)

function chooseGameMode(sender)
         if (Main_GameModeList.ItemIndex == 0) then
                -- Regular
                gameMode = 0;
                Main_StreetUIToggleBox.setEnabled(true);
         elseif (Main_GameModeList.ItemIndex == 1) then
                -- Last Man Standing
                gameMode = 1;
                Main_StreetUIToggleBox.setEnabled(true);
         elseif (Main_GameModeList.ItemIndex == 2) then
                -- Skills Battle
                gameMode = 2;
                checkbox_setState(Main_StreetUIToggleBox, 1);
                toggleStreetUI();
         end
end


-- Choose the goal size (WxLxD in DB):
-- 0: Regular futsal-sized (300x250x150)
-- 1: Long and low street goal (408x94x100)
-- 2: Mini goal (87x75x200)

function chooseGoalSize(sender)
         if (Main_GoalSizeList.ItemIndex == 0) then
                goalWidth = 5.14;
                goalHeight = 8.0;
         elseif (Main_GoalSizeList.ItemIndex == 1) then
                goalWidth = 6.9;
                goalHeight = 3.1;
         elseif (Main_GoalSizeList.ItemIndex == 2) then
                goalWidth = 1.4;
                goalHeight = 2.4;
         end
end

-- Get the number of players chosen
function getNumPlayers(sender)
         if (Main_NumPlayersRadioGroup.ItemIndex == 0) then
            numPlayersPerTeam = 5;
         end
         if (Main_NumPlayersRadioGroup.ItemIndex == 1) then
            numPlayersPerTeam = 4;
         end
         if (Main_NumPlayersRadioGroup.ItemIndex == 2) then
            numPlayersPerTeam = 3;
         end
         if (Main_NumPlayersRadioGroup.ItemIndex == 3) then
            numPlayersPerTeam = 2;
         end
         if (Main_NumPlayersRadioGroup.ItemIndex == 4) then
            numPlayersPerTeam = 1;
         end

         minRemainingPlayers = numPlayersPerTeam;
end

-- Goalkeepers on the field or not
function enableGoalie()

         if (Main_GoalieToggleBox.getState() == 1) then
            goalieEnabled = true;
            outfieldPlayers = 11 - numPlayersPerTeam;
            Main_GoalieToggleBox.setCaption("Goalie");
         else
             goalieEnabled = false;
             -- If goalkeepers are disabled, then decrease the number of
             -- outfield players to remove
             outfieldPlayers = 10 - numPlayersPerTeam;
             Main_GoalieToggleBox.setCaption("No Goalie");
         end
end

-- Run required scripts for skill battle game mode
function setupSkillBattle()

         storeSkillMoveID =
         [[
            globalAlloc(skillmoveOccurs, 256,"fifa16.exe"+4E2A9B9)
            globalAlloc(skillmoveID, 4, "fifa16.exe"+4E2A9B9)
            label(returnhere)
            label(exit)



            skillmoveOccurs:

            mov r12d,eax
            mov [skillmoveID], r12d
            test ebp,ebp

            exit:
            jmp returnhere


            "fifa16.exe"+4E2A9B9:
            jmp skillmoveOccurs
            returnhere:
         ]];

         fancyPassShotEvent =
         [[
            globalAlloc(fancyPassShotOccurs,256,"fifa16.exe"+50B1FD7)
            globalAlloc(fancyPassShot, 8, "fifa16.exe"+50B1FD7)
            label(returnhere)
            label(exit)

            fancyPassShotOccurs:
            movss [fancyPassShot], xmm0
            movss [rdi+00000084],xmm0

            exit:
            jmp returnhere

            "fifa16.exe"+50B1FD7:
            jmp fancyPassShotOccurs
            nop
            nop
            nop
            returnhere:
         ]];

         increasePassCounterRange =
         [[
            globalAlloc(passCount,256,"fifa16.exe"+44A056E)
            label(returnhere)
            label(exit)

            passCount:

            cmp ecx,FFFFFFF
            jnl 1444A0578

            exit:
            jmp returnhere

            "fifa16.exe"+44A056E:
            jmp passCount
            returnhere:
         ]];

         ballTouchEvent =
         [[
            globalAlloc(ballTouch, 128,"fifa16.exe"+508A2F0)
            globalAlloc(ballTouchCounter, 8, "fifa16.exe"+508A2F0)
            label(returnhere)
            label(exit)

            ballTouchCounter:
            dw 0

            ballTouch:
            mov al,01
            inc [ballTouchCounter]
            add rsp,28

            exit:
            jmp returnhere

            "fifa16.exe"+508A2F0:
            jmp ballTouch
            nop
            returnhere:
         ]];

         skillmoveEvent =
         [[
            globalAlloc(skillmoveCheck,2048,"fifa16.exe"+4E28612)
            globalAlloc(skillmoveCounter, 8, "fifa16.exe"+4E28612)
            label(returnhere)
            label(exit)

            skillmoveCounter:
            db 00

            skillmoveCheck:
            mov rax,[r13+58]
            lea rcx,[r13+58]
            inc [skillmoveCounter]

            exit:
            jmp returnhere

            "fifa16.exe"+4E28612:
            jmp skillmoveCheck
            nop
            nop
            nop
            returnhere:
         ]]

         tackleCheck =
         [[
            globalAlloc(tackleCheck,128,"fifa16.exe"+5171C5B)
            globalAlloc(tackleResult, 8, "fifa16.exe"+5171C5B)
            label(returnhere)
            label(exit)

            tackleResult:
            db 0

            tackleCheck:

            cmp dword ptr [rdi+00000240],00
            mov eax, dword ptr [rdi+00000240]
            mov [tackleResult], eax

            exit:
            jmp returnhere

            "fifa16.exe"+5171C5B:
            jmp tackleCheck
            nop
            nop
            returnhere:

         ]]

         increaseTackleCounterRange =
         [[
            globalAlloc(tackleCount,128,"fifa16.exe"+44A06A0)
            label(returnhere)
            label(exit)

            tackleCount:
            cmp eax,FFFFFFF
            jnl 1444A06AA
            inc eax

            exit:
            jmp returnhere

            "fifa16.exe"+44A06A0:
            jmp tackleCount
            nop
            returnhere:

         ]]

         playerWinningPossession =
         [[
            globalAlloc(possession,128,"fifa16.exe"+4E5B5CC)
            globalAlloc(playerPossession, 8, "fifa16.exe"+4E5B5CC)
            label(returnhere)
            label(originalcode)
            label(exit)

            playerPossession:
            db 0

            possession:
            mov [playerPossession], r8d

            originalcode:
            mov r15d,r8d
            mov ebp,edx

            exit:
            jmp returnhere

            "fifa16.exe"+4E5B5CC:
            jmp possession
            returnhere:
         ]]

         freekickEvent =
         [[
            globalAlloc(fkCount,128,"fifa16.exe"+4FE3E56)
            globalAlloc(fkCounter, 8, "fifa16.exe"+4FE3E56)
            label(returnhere)
            label(originalcode)
            label(exit)

            fkCounter:
            db 0

            fkCount:
            inc [fkCounter]

            originalcode:
            lea rdx,[1421032A0]

            exit:
            jmp returnhere

            "fifa16.exe"+4FE3E56:
            jmp fkCount
            nop
            nop
            returnhere:
         ]]


         autoAssemble(storeSkillMoveID);
         autoAssemble(fancyPassShotEvent);
         autoAssemble(increasePassCounterRange);
         autoAssemble(ballTouchEvent);
         autoAssemble(skillmoveEvent);
         autoAssemble(tackleCheck);
         autoAssemble(increaseTackleCounterRange);
         autoAssemble(playerWinningPossession);
         autoAssemble(freekickEvent);

end

-- Removes out-of-play rules and anticipate-OOP animations.
function enableWalls(sender)

         if (Main_WallsToggleBox.getState() == 1) then
               changeOOP(false);
               Main_WallsToggleBox.setCaption("Walls Enabled");
               wallTimer.setEnabled(true);
               timer_onTimer(wallTimer, startForceField);

         elseif (Main_WallsToggleBox.getState() == 0) then
               changeOOP(true);
               Main_WallsToggleBox.setCaption("Walls Disabled");
               wallTimer.setEnabled(false);
         end

end

-- Remove or re-enable out of play rules
function changeOOP(enable)
         BallOOP = "";
         if (enable) then
            BallOOP =
            [[

               145016183:
               inc eax
               cmp eax, 0

               144D0303B:
               mov al,01

               144D044CB:
               mov al,01

               144D0445D:
               mov [rsp+20],00000001

            ]];
         else
             BallOOP =
             [[

               145016183:
               inc eax
               cmp eax, 0

               144D0303B:
               mov al,00


               144D044CB:
               mov al,00

               144D0445D:
               mov [rsp+20],00000000

             ]];
         end

         autoAssemble(BallOOP);

end

function setRemovablePlayers()
         index = 1;

         for k, v in pairs(playersArray) do
             playersArray[k]["onField"] = true;
         end

         while (index <= outfieldPlayers*2) do
               playersArray[index]["onField"] = false;
               index = index + 1;
         end

         if not(goalieEnabled) then
               playersArray[21]["onField"] = false;
               playersArray[22]["onField"] = false;
         end


         if (gameMode == 1) then
            indexHome = outfieldPlayers*2 + 1;
            indexAway = outfieldPlayers*2 + 2;

            removeExtraPlayers(hGoalsCount, indexHome);
            removeExtraPlayers(aGoalsCount, indexAway);
         end

         repositionPlayers();



end

-- In case the ball goes out of play, disable the barrier and allow
-- the player to reposition themselves on the field.
-- Once the ball is back in play, move them back off again and
-- reinitiate the barrier.
-- TODO: move only the RS and the Goalies on each side for setplay requirements.
function repositionPlayers()

         setplay = (tonumber(reposition.getValue()) == 1 and tonumber(ballXM.getValue()) == 0 and tonumber(endOfHalf.getValue()) == 0);
         setplayTakerID = tonumber(possessorID.getValue());
         setplayTakerRecordIndex = nil;
         players = nil;

         if (setplay) then

            isFreekick = (freekickCount < tonumber(freekickCounter.getValue()));

            if not(setplayStart) then
               setplayStart = true;
               timeSinceFK = os.clock();
            end

            freezeDist = 500;
            for k, v in pairs(playersArray) do
                if (playersArray[k]["ID"] == setplayTakerID) then
                    playersArray[k]["onField"] = true;
                    setplayTakerRecordIndex = k;
                end
            end

            players = {[1]=setplayTakerRecordIndex, [2]=21, [3]=22, [4]=17, [5]=18};

            for k, v in pairs(players) do
               playersArray[v]["onField"] = true;
               if (math.abs(tonumber(playersArray[v]["pos"].getValue())) > 80) then
                  playersArray[v]["pos"].setValue(0);
               end
            end

            if (isFreekick) then
               if (os.clock() - timeSinceFK > 7) then
                  removePlayersTimer.setEnabled(false);
                  for k, v in pairs(playersArray) do
                      if (tonumber(playersArray[k]["pos"].getValue()) > 60) then
                         playersArray[k]["pos"].setValue(0);
                      end
                  end

                  while (tonumber(reposition.getValue()) == 1) do
                 -- wait
                  end
                  removePlayersTimer.setEnabled(true);
               end
            end



         else

             setplayStart = false;
             freezeDist = 500;
             if (isFreekick) then
                freekickCount = tonumber(freekickCounter.getValue());
                isFreeKick = false;
             end
         end

end

-- Create a barrier around the pitch that prevents the ball
-- from going out of play.
-- Done for a fun street-like experience and to prevent some
-- game-breaking bugs that occur when a throw-in or corner occurs.
function startForceField()
         if (tonumber(homeLS.getValue()) ~= nil and tonumber(ballXM.getValue()) ~= nil) then
            gameReady = true;
            pYP = ballYPos.getCurrentAddress();
            pXP = ballXPos.getCurrentAddress();
            pZP = ballZPos.getCurrentAddress();
            pYM = ballYM.getCurrentAddress();
            pXM = ballXM.getCurrentAddress();
            pZM = ballZM.getCurrentAddress();
         else
             gameReady = false;
         end

         if (gameReady) then
            -- almost out along sideline
            if (readFloat(pXP) > 41.0) then -- 40.0, 2.0
                writeFloat(pXP, 41.0);
                writeFloat(pXM, -mMult*readFloat(pXM));
                ballHitWall = true;
            elseif (readFloat(pXP) < -41.0) then -- -40.0, 2.0
                writeFloat(pXP, -41.0);
                writeFloat(pXM, -mMult*readFloat(pXM));
                ballHitWall = true;
            elseif(readFloat(pYP) > 68.5) then -- 68.3, 1.6
              if((readFloat(pXP) > goalWidth) or (readFloat(pXP) < -goalWidth)) then
                    writeFloat(pYP, 68.5);
                    writeFloat(pYM, -mMult*readFloat(pYM));
                    ballHitWall = true;
              else
                  if(readFloat(pZP) > goalHeight) then --old: 9.0
                     writeFloat(pYP, 68.5);
                     writeFloat(pYM, -mMult*readFloat(pYM));
                     ballHitWall = true;
                  end
              end
            elseif(readFloat(pYP) < -68.5) then -- -68.3, 1.6
              if((readFloat(pXP) > goalWidth) or (readFloat(pXP) < -goalWidth)) then
                   writeFloat(pYP, -68.5);
                   writeFloat(pYM, -mMult*readFloat(pYM));
                   ballHitWall = true;
              else
                  if(readFloat(pZP) > goalHeight) then --old: 9.0
                     writeFloat(pYP, -68.5);
                     writeFloat(pYM, -mMult*readFloat(pYM));
                     ballHitWall = true;
                  end
              end
            end
         end

end

-- Removes players depending on what game mode/num players combo
-- was selected.

function removePlayers()
         -- Check to see if the game has started
         if (tonumber(kickoff.getValue()) ~= nil) then

           -- Reset walls at start and reposition first if necessary
           if (not(wallCheck)) then
              enableWalls();
              wallCheck = true;
           end

           if (tonumber(newGameStarted.getValue()) == 1 and not(newGame)) then
              setRemovablePlayers();
              freekickCount = 0;
              freekickCounter.setValue(0);
              newGame = true;
           end

           index = 1;

           -- Regular
           if (gameMode == 0 or gameMode == 2) then

              -- Any injury time added on at all
              -- can cause the match to not end
              -- until a team scores and
              -- the other team kicks off.
              -- Removing injury time (+0)
              -- ends the game more promptly.
              if ((tonumber(time.getValue()) == 2700) or
                  (tonumber(time.getValue()) == 5400) or
                  (tonumber(time.getValue()) == 6300) or
                  (tonumber(time.getValue()) == 7200)) then
                  if not(endedHalf) then
                     wallTimer.setEnabled(false);
                     changeOOP(true);
                     timer_onTimer(removePlayersTimer, endHalf);

                  end
              else
                   endedHalf = false;
              end
              addedTimeScale.setValue(60.0);
              timeScale.setValue(45/tonumber(halfLength.getValue()));
           end

           if (gameMode == 1) then

               if (tonumber(newGameStarted.getValue()) == 1) then
                  timeScale.setValue(0);
                  removePlayersTimer.setEnabled(false);
                  removePlayersTimer.setInterval(500);
                  removePlayersTimer.setEnabled(true);
                  hGoalsCount = 0;
                  aGoalsCount = 0;
               end

               if (tonumber(homeGoals.getValue()) ~= nil and tonumber(awayGoals.getValue()) ~= nil) then
                 LMSRemovePlayers();
               end
           end

           setRemovablePlayers();
           for k, v in pairs(playersArray) do
                  if not(playersArray[k]["onField"]) then
                     playersArray[k]["pos"].setValue(freezeDist);
                  end
           end

           if ((tonumber(time.getValue()) == 5400 and tonumber(endOfHalf.getValue()) == 1) or
               (tonumber(time.getValue()) == 7200 and tonumber(endOfHalf.getValue()) == 1)) then
              newGame = false;
           end


         end
end


-- Remove extra players depending on goals scored
function removeExtraPlayers(goalsScored, index)
         while (goalsScored > 0) do
               playersArray[index]["onField"] = false;
               goalsScored = goalsScored - 1;
               index = index + 2;
         end

end

-- Remove players depending on the number of goals scored for each team.
-- Set time scale to large number and send ball out of play when
-- one team reaches 5 goals. (done to trigger end-of-half)

function LMSRemovePlayers()


         if (hGoalsCount < tonumber(homeGoals.getValue())) then
               hGoalsCount = tonumber(homeGoals.getValue());
         elseif (aGoalsCount < tonumber(awayGoals.getValue())) then
               aGoalsCount = tonumber(awayGoals.getValue());
         end


         maxGoals = math.max(hGoalsCount, aGoalsCount);

         if (maxGoals == numPlayersPerTeam) then

            wallTimer.setEnabled(false);
            changeOOP(true);
            -- gameWon();
            minRemainingPlayers = 5;
            maxGoals = 0;
            wallCheck = false;
            timer_onTimer(removePlayersTimer, endHalf);
            return;
         end


         if ((numPlayersPerTeam - maxGoals) < minRemainingPlayers) then
            minRemainingPlayers = numPlayersPerTeam - maxGoals;
         end

end

-- A team has no players left on the field and has won
-- the match. Freeze ball upon kickoff.


function endHalf()

        timeScale.setValue(90000);
        addedTimeScale.setValue(1);


        isEndOfHalf = false;

        if (tonumber(endOfHalf.getValue()) == 0) then
               ballXPos.setValue(xPos);
               ballXM.setValue(0);
               ballYM.setValue(0);
               ballYPos.setValue(0);
               ballZM.setValue(0);
               ballZPos.setValue(0.365);

               if (tonumber(reposition.getValue()) == 0) then
                   i = 1;
                   while (i <= 22) do
                         playersArray[i]["pos"].setValue(freezeDist);
                         i = i + 1;
                   end
               else
                   repositionPlayers();
                   xPos = 0;
               end
        else
            xPos = 44;
            endedHalf = true;
            wallCheck = false;
            timer_onTimer(removePlayersTimer, removePlayers);
        end



end

-- A team has no players left on the field and has won
-- the match. Freeze ball upon kickoff.
function gameWon()
          hGoalsCount = 5;
          aGoalsCount = 5;

          ballXM.setValue(0);
          ballXPos.setValue(0);
          ballYM.setValue(0);
          ballYPos.setValue(0);
          ballZM.setValue(0);
          ballZPos.setValue(0);
          addedTimeScale.setValue(1);
          timeScale.setValue(90000);
end

-- Keep track of skill point tallies
-- and update scoreboard to reflect changes
function skillScoreKeeper()

         -- Show Street UI only when in match
         if (tonumber(isInMenu.getValue()) == 1 and not(changedVisibility)) then
            changedVisibility = true;
            form_hide(StreetUI);
         elseif (tonumber(isInMenu.getValue()) == 0 and changedVisibility) then
             changedVisibility = false;
             form_show(StreetUI);
             StreetUI.setPosition(xPosUI, yPosUI);
         end

         -- At the end of the game, if Skillbattle is chosen, input score
         if (gameMode == 2 and (tonumber(time.getValue()) == 5400 or tonumber(time.getValue()) == 7200)) then
            homeScore.setValue(skillPtsTotal[1]);
            awayScore.setValue(skillPtsTotal[2]);
         end

         if (tonumber(homeScore.getValue()) ~= nil and
             tonumber(awayScore.getValue()) ~= nil and
             tonumber(homeCompletedPasses.getValue()) ~= nil and
             tonumber(awayCompletedPasses.getValue()) ~= nil and
             tonumber(kickoff.getValue()) ~= nil) then

           -- Get current team in possession
           getTeamInPossession();
           -- Check for skillmove
           checkForSkillmove();
           -- Check for fancy pass/shot, wallpass, and nutmeg
           checkForFancyAnimation();
           -- Check if the sequence of play is complete
           -- Add to team skill point total if so
           addSkillPointsToTotal();
           -- Update the scoreboard with the new point totals
           updateScoreboard();

           -- Reset counter and score variables when starting new game
           if (tonumber(newGameStarted.getValue()) == 1) then
              homeScore.setValue(0);
              awayScore.setValue(0);
              skillPtsTotal[1] = 0;
              skillPtsTotal[2] = 0;
              compPasses[1] = 0;
              compPasses[2] = 0;
              goalsTotal[1] = 0;
              goalsTotal[2] = 0;
              passCount = 0;
              shotCount = 0;
              wallPassCount = 0;
              wallBallTouchCount = 0;
              skillmoveCount = 0;
              tackleCount = 0;
              ballTouchCounter.setValue(0);
              ballTouchCount = 0;
              tackleResult.setValue(0);
              skillmoveCount = 0;
              skillmoveCounter.setValue(0);
              StreetUI_HomeScore.setCaption("0");
              StreetUI_AwayScore.setCaption("0");
              StreetUI_SkillInfoLabel.setCaption("New Game");
           end
         end
end

-- Gets the team in possession and checks if a dribble possesion
-- is in progress
function getTeamInPossession();

         -- Reset temporary skill points pools, related register variables,
         -- and update team in possession.

         currentTeamInPoss = tonumber(playerPossession.getValue());

         if (currentTeamInPoss < 11) then
            currentTeamInPoss = 1;
         elseif (currentTeamInPoss >= 11 and currentTeamInPoss < 255) then
                currentTeamInPoss = 2;
         elseif (currentTeamInPoss == 255) then
            currentTeamInPoss = tonumber(teamPossession.getValue()) + 1;
         end

         -- Determine which team scored
         goalScored = goalCheck();
         if (goalScored ~= -1) then
            currentTeamInPoss = goalScored;
         end

         -- Reset score-calculation variables upon change of possession
         if (teamInPossession ~= currentTeamInPoss) then
            skillmovePts = 0;
            lastSkillmoveID = 0;
            dribblePossessionSkills = 0;
            nutmegOccurred = false;
            totalDefendersBeaten = 0;
            beatDefenders = 0;
            fancyPassShotCount = 0;
            accumulateSkillBeatPts = false;
            teamInPossession = currentTeamInPoss;
            ballTouchCount = tonumber(ballTouchCounter.getValue());


            if (lastTeamBallTouch ~= tonumber(teamBallTouch.getValue())+1) then
               potentialWallPass = false;
               ballHitWall = false;
            end
            -- In case the read-in value glitches
            -- Prevents lua error message
            if (teamInPossession == 3) then
               teamInPossession = 2;
            end

            fancyAnimations =
            {
                   ["fancyPass"] = {[1]=false, [2]=100, [3]="Flair Pass"},
                   ["rabona"]    = {[1]=false, [2]=150, [3]="Rabona"},
                   ["scoopPass"] = {[1]=false, [2]=125, [3]="Scoop Pass"},
                   ["fancyShot"] = {[1]=false, [2]=150, [3]="Flair Shot"}
            };
            StreetUI_SkillBankPoints.setCaption("0");
         end

end

-- Checks to see if the possessing team scored
-- Tallies up point totals and returns results
function goalCheck()

         -- First, check for possessor-team goal
         -- Then, check for own goal
         hGoals = tonumber(homeGoals.getValue());
         aGoals = tonumber(awayGoals.getValue());


         if (goalsTotal[1] < hGoals) then
            goalsTotal[1] = hGoals;
            isGoal = true
            return 1;
         elseif (goalsTotal[2] < aGoals) then
                goalsTotal[2] = aGoals;
                isGoal = true;
                return 2;
         else
             return -1;
         end
end

-- Check if a skillmove has occurred and sum points if neccessary
function checkForSkillmove()

         -- Currently, to register points, skillmoves changed together
         -- must be unique back-to-back.
         -- Done to due to current skillmove register address
         -- still maintaining its value until the ball-touch
         -- after the skillmove animation completes.
         currentSkillmoveID = tonumber(skillmoveID.getValue());
         currentSkillmoveCount = tonumber(skillmoveCounter.getValue());

         if (currentSkillmoveCount == nil) then
            return;
         end

         if (skillmoveCount < currentSkillmoveCount) then
            if (skillmoveDB[currentSkillmoveID] ~= nil) then
               skillmovePts = skillmovePts + skillmoveDB[currentSkillmoveID][2];
            else
                skillmovePts = 50;
            end

            if (lastSkillmoveID == 44) then
               if (currentSkillmoveID == 57 or currentSkillmoveID == 77 or currentSkillmoveID == 76) then
                  skillmovePts = skillmovePts + skillmoveDB[tostring(currentSkillmoveID)][2];
                  currentSkillmoveID = tostring(currentSkillmoveID);
               end
            end

            dribblePossessionSkills = dribblePossessionSkills + 1;
            skillmoveCount = currentSkillmoveCount;
            lastSkillmoveID = currentSkillmoveID;

            if (skillmoveDB[currentSkillmoveID] ~= nil) then
              StreetUI_SkillInfoLabel.Font.Color = controlColorList[skillmoveDB[currentSkillmoveID][3]];
              StreetUI_SkillInfoLabel.setCaption(skillmoveDB[currentSkillmoveID][1]..": "..
                                                 math.floor(skillmoveDB[currentSkillmoveID][2]).." Points");
            else
                StreetUI_SkillInfoLabel.Font.Color = controlColorList[4];
                StreetUI_SkillInfoLabel.setCaption("Bag of tricks: 50 Points");
            end

            StreetUI_SkillBankPoints.setCaption(math.floor(skillmovePts));
         end
end

-- Check if a fancy pass/cross/shot animation executes.
-- Update points if so.
function checkForFancyAnimation()

         currentPassCount = tonumber(passCounter.getValue());
         currentShotCount = tonumber(shotCounter.getValue());
         fancyPassShotID = readSmallInteger(fancyPassShot.getAddress());
         currentBallTouchCount = tonumber(ballTouchCounter.getValue());



         if (passCount < currentPassCount and
             fancyPassShotID > 0) then
             if (fancyPassShotID == 1) then
                fancyAnimations["fancyPass"][1] = true;
             elseif (fancyPassShotID == 14336) then
                    fancyAnimations["rabona"][1] = true;
             elseif (fancyPassShotID == 55296) then
                    fancyAnimations["scoopPass"][1] = true;
             end

         elseif (shotCount < currentShotCount and
                 fancyPassShotID > 0) then
                 if (fancyPassShotID == 1) then
                    fancyAnimations["fancyShot"][1] = true;
                 elseif (fancyPassShotID == 14336) then
                        fancyAnimations["fancyShot"][1] = true;
                 end
         elseif (not(nutmegOccurred) and tonumber(nutmeg.getValue()) == 2) then
                nutmegOccurred = true;
                lastTeamBallTouch = tonumber(teamBallTouch.getValue())+1;
         elseif (tonumber(nutmeg.getValue()) == 0) then
                nutmegOccurred = false;
                nutmegPtsAdded = false;
         end
         -- Setup for wallpass check
         -- The next balltouch after hitting
         -- a wall must be taken by
         -- the team that played the pass
         if (passCount < currentPassCount and not(potentialWallPass)) then
            potentialWallPass = true;
            ballTouchCount = currentBallTouchCount;
            lastTeamBallTouch = tonumber(teamBallTouch.getValue())+1;
         end

end

-- Add accumulated skill points to total when possession sequence ends
function addSkillPointsToTotal()

         beatDefPts = beatDefenderEvaluation();
         passShotPts = passShotEvaluation();
         goalPts = goalEvaluation();

         -- Update total points
         if (accumulateSkillBeatPts) then
            skillPtsTotal[teamInPossession] = skillPtsTotal[teamInPossession]
                                         + beatDefPts;
         end

         skillPtsTotal[teamInPossession] = skillPtsTotal[teamInPossession]
                                         + passShotPts + goalPts;

         -- Get ready for the next thread's execution
         resetVariables();

end

-- Check if attacker beat defender and add
-- temp skill points to total
function beatDefenderEvaluation()

         currentTackleCount = tonumber(tackleCounter.getValue());
         -- Blue for beats

         accumulateSkillBeatPts = false;
         if (tonumber(dribblePossession.getValue()) ~= 254) then
            newDefBeaten = tonumber(defendersBeaten.getValue()) - totalDefendersBeaten;
            if (newDefBeaten > 0) then
               StreetUI_SkillInfoLabel.Font.Color = 0xFFCC00;
               beatDefenders = beatDefenders + newDefBeaten;
               if (dribblePossessionSkills == 0) then
                  skillmovePts = math.floor(BEAT_DEF_BASE_PTS * beatDefenders);
                  StreetUI_SkillInfoLabel.setCaption("Beat (x"..beatDefenders.."): +"..skillmovePts);
               else
                   skillmovePts  = math.floor((BEAT_DEF_BASE_PTS + skillmovePts) *
                                               beatDefenders * (1 + 0.25*dribblePossessionSkills));
                   StreetUI_SkillInfoLabel.setCaption(dribblePossessionSkills..
                                                      " Skill Beat (x"..beatDefenders.."): +"..skillmovePts);
               end

               totalDefendersBeaten = totalDefendersBeaten + newDefBeaten;
               accumulateSkillBeatPts = true;
            end

            -- Check for missed tackle
            if (tackleCount < currentTackleCount and
                tonumber(tackleResult.getValue()) == 255) then
                StreetUI_SkillInfoLabel.Font.Color = 0xFFCC00;
                if (skillmovePts == 0) then
                   skillmovePts = math.floor(FORCED_TACKLE_MISS_PTS);
                   StreetUI_SkillInfoLabel.setCaption("See you later: +"..skillmovePts);
                else
                    skillmovePts = math.floor((FORCED_TACKLE_MISS_PTS + skillmovePts) * FORCED_TACKLE_MISS_MULT);
                    StreetUI_SkillInfoLabel.setCaption("Left in the dust: +"..skillmovePts);
                end
                accumulateSkillBeatPts = true;
                tackleCount = currentTackleCount;
            end
         end

         return skillmovePts;

end

-- Check if a pass was completed
-- an/or if a team scored and add
-- pass/shot skill points to total
function passShotEvaluation()

         currentPassCount = tonumber(passCounter.getValue());
         currentShotCount = tonumber(shotCounter.getValue());

         homeCompPassCount = tonumber(homeCompletedPasses.getValue());
         awayCompPassCount = tonumber(awayCompletedPasses.getValue());

         if (homeCompPassCount == nil) then
            return 0;
         end

         currentCompPasses = {[1]=homeCompPassCount, [2]=awayCompPassCount};
         passShotPts = 0;

         currentBallTouchCount = tonumber(ballTouchCounter.getValue());

         -- Purple for flair touches


         if (compPasses[teamInPossession] < currentCompPasses[teamInPossession] or
             shotCount < tonumber(shotCounter.getValue())) then
            for k, v in pairs(fancyAnimations) do
                if (fancyAnimations[k][1]) then
                   passShotPts = passShotPts + v[2];
                   fancyAnimations[k][1] = false;
                   fancyPassShotCount = fancyPassShotCount + 1;
                   StreetUI_SkillInfoLabel.Font.Color = 0x00FF00BB;
                   StreetUI_SkillInfoLabel.setCaption(fancyAnimations[k][3]..": +"..fancyAnimations[k][2]);
                end
            end
         end

         -- Check for completed wallpass
         if (potentialWallPass and ballTouchCount < currentBallTouchCount and ballHitWall) then
             if (lastTeamBallTouch == tonumber(teamBallTouch.getValue())+1) then
               passShotPts = math.floor((passShotPts + SKILLPASS_PTS)* WALLPASS_MULT);
               fancyPassShotCount = fancyPassShotCount + 1;
               StreetUI_SkillInfoLabel.Font.Color = 0x00FF00BB;
               StreetUI_SkillInfoLabel.setCaption("Wall Pass"..": +"..passShotPts);
             end
             ballHitWall = false;
             potentialWallPass = false;
         elseif (potentialWallPass and
                 ballTouchCount < currentBallTouchCount and not(ballHitWall)) then
                 potentialWallPass = false;
         elseif (not(potentialWallPass) and ballHitWall) then
                ballHitWall = false;
         end


         -- Check for nutmeg
         -- Only skill move that may have points added for the
         -- defending team if the touch producing the nutmeg
         -- came from a tackle.
         if (nutmegOccurred and not(nutmegPtsAdded)) then
            passShotPts = math.floor(passShotPts + NUTMEG_PTS);
            nutmegOccurred = false;
            nutmegPtsAdded = true;
            if (teamInPossession == lastTeamBallTouch) then
               fancyPassShotCount = fancyPassShotCount + 1;
            else
                skillPtsTotal[lastTeamBallTouch] = skillPtsTotal[lastTeamBallTouch] + NUTMEG_PTS;
            end
            StreetUI_SkillInfoLabel.Font.Color = 0x00FF00BB;
            StreetUI_SkillInfoLabel.setCaption("Panna"..": +"..NUTMEG_PTS);
         end

         compPasses[teamInPossession] = currentCompPasses[teamInPossession];
         shotCount = currentShotCount;

         passCount = currentPassCount;

         ballTouchCount = currentBallTouchCount;
         return passShotPts;
end

-- Sums up points for goal based on number of defenders beaten
-- and fancy passes/shots performed
function goalEvaluation()

         goalStylePtsMult = 1 + totalDefendersBeaten + (fancyPassShotCount*0.33) + (0.1*dribblePossessionSkills) ;
         -- Orange for goal scored

         if (isGoal) then
            StreetUI_SkillInfoLabel.Font.setColor(0x0076E8);
            isGoal = false;
            goalPts = math.floor((GOAL_BASE_PTS * GOAL_PTS_MULT * goalStylePtsMult) + skillmovePts);
            StreetUI_SkillInfoLabel.setCaption("Home Goal! Beat (x"..totalDefendersBeaten..
                                               "), Flair Touches (x"..fancyPassShotCount.."): +"..goalPts);
            return goalPts;
         else
             return 0;
         end
end

-- Reset variables related to skill-point accumulation calculations
function resetVariables()

         if (accumulateSkillBeatPts) then
            skillmovePts = 0;
            lastSkillmoveID = 0;
            dribblePossessionSkills = 0;
            nutmegOccurred = false;
            accumulateSkillBeatPts = false;
         end
end

-- Update the scoreboard with new point totals
function updateScoreboard()
         StreetUI_HomeScore.setCaption(math.floor(skillPtsTotal[1]));
         StreetUI_AwayScore.setCaption(math.floor(skillPtsTotal[2]));
end

-- Setup Street UI
function setupStreetUI()
         -- form_show(StreetUI);
         setProperty(StreetUI, "ShowInTaskBar", "stAlways");

         -- Credits to mgr.inz.Player from the CE forums
         -- for the transparent window code.
         StreetUI.BorderStyle = 'bsNone';
         StreetUI.Color = 0x00;
         StreetUI.setLayeredAttributes(0x00, 235, 3);
         StreetUI.FormStyle="fsSystemStayOnTop";
end

-- Reposition scoreboard event (mouse click + drag)
function dragScoreboard()
         StreetUI.dragNow();
         xPosUI = StreetUI.getLeft();
         yPosUI = StreetUI.getTop();
end

-- Show street UI if option enabled
function toggleStreetUI()

         if (Main_StreetUIToggleBox.getState() == 0) then
             Main_StreetUIToggleBox.setCaption("No Street UI");
             skillBattleTimer.setEnabled(false);
             form_hide(StreetUI);
         elseif (Main_StreetUIToggleBox.getState() == 1 and gameMode ~= 2) then
             Main_StreetUIToggleBox.setCaption("Street UI");
             skillBattleTimer.setEnabled(true);
             timer_onTimer(skillBattleTimer, skillScoreKeeper);
         else
             Main_StreetUIToggleBox.setCaption("Street UI");
             Main_StreetUIToggleBox.setEnabled(false);
             checkbox_setState(Main_StreetUIToggleBox,0);
             skillBattleTimer.setEnabled(true);
             timer_onTimer(skillBattleTimer, skillScoreKeeper);
         end

         StreetUI.setPosition(xPosUI, yPosUI);
end




-- Flip setting for toggle box
function toggleSettings(toggleBox, toggleFunction)
         if (toggleBox.getEnabled()) then
             newSetting = math.abs(toggleBox.getState() - 1);
             checkbox_setState(toggleBox, newSetting);
             toggleFunction();
         end
end

-- Return parameterless function for use in hotkey enabler
function toggleClosure(settingsToggle, toggleBox, toggleFunction)
         local args = {toggleBox, toggleFunction};
         return function()
                settingsToggle(unpack(args));
         end
end

-- Four hotkeys:
-- 1. Re-open FIFA process if game crashed
-- 2. Enable/disable the mod
-- 3. Enable/disable walls
-- 4. Enable/disable Street UI
function FIFAHotkeys()
         setGlobalDelayBetweenHotkeyActivation(1000);
         attachHK = createHotkey(openFIFAProcess, VK_SHIFT, VK_F5);
         enableHK = createHotkey(enableMod, VK_SHIFT, VK_F6);
         wallsToggle = toggleClosure(toggleSettings, Main_WallsToggleBox, enableWalls);
         streetUIToggle = toggleClosure(toggleSettings, Main_StreetUIToggleBox, toggleStreetUI);
         wallsHK = createHotkey(wallsToggle, VK_SHIFT, VK_F7);
         streetUIHK = createHotkey(streetUIToggle, VK_SHIFT, VK_F8);
end

-- Create main form
createFormFunctionality();
-- Create hotkeys
FIFAHotkeys();

attachTimer.setEnabled(true);
timer_onTimer(attachTimer, openFIFAProcess);
