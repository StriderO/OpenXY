function [EMsoftPath EMdataPath] = GetEMsoftPath
%Check for EMsoft - this file is set up for EMsoft version 5, July 2020
EMsoftPath = '';
sysSettings = matfile('SystemSettings.mat', 'Writable', true);
if isprop(sysSettings, 'OpenXYPath')
    OpenXYPath = sysSettings.OpenXYPath;
else
    OpenXYPath = fileparts(which('MainGUI'));
end
if ~exist('EMsoftPath','var') || isempty(EMsoftPath) || ~exist('EMdataPath','var') || isempty(EMdataPath)
    sel = questdlg({'EMsoft required, but no path has been specified';'Is EMsoft installed on the local computer?'},'EMsoft not found','Yes','No','Yes');
    if strcmp(sel,'Yes')
        msgbox('Select directory with EMsoftConfig.json (usually in /Users/**you**/.congig/EMsoft/); press shift/command/G to show hidden directories on a Mac');
        EMconfigPath = uigetdir('Select directory with EMsoftConfig.json');
        EMsc=textread([EMconfigPath,'/EMsoftConfig.json'],'%s','delimiter','\n');
        temp=EMsc{2};
        slash=strfind(temp,'/');
        EMsoftPath=temp(slash(1):slash(end));
        temp=EMsc{4};
        slash=strfind(temp,'/');
        EMdataPath=temp(slash(1):slash(end));
    else
        warndlgpause('Cannot use dynamically simulated patterns. Resetting to kinematic simulation.','EMsoft not found');
        return;
    end
else
    EMsoftPath = sysSettings.EMsoftPath;
end
%Check if EMEBSD command exists
commandName = fullfile(EMsoftPath,'EMEBSD');
if ispc
    commandName = [commandName '.exe'];
end
if ~exist(commandName,'file')
    warndlgpause({['EMEBSD command not found in ' fullfile(EMsoftPath,'bin') ','],'Resetting to kinematic simulation; resetting EMsoft path.'},'EMsoft not found');
    EMsoftPath = '';
    save('SystemSettings.mat','OpenXYPath');
else
    save('SystemSettings.mat','OpenXYPath','EMsoftPath','EMdataPath');
end

function warndlgpause(msg,title)
h = warndlg(msg,title);
uiwait(h,7);
if isvalid(h); close(h); end;
