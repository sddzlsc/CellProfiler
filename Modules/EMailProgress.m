function handles = AlgEMailProgress(handles)

% Help for the E-Mail Progress module:
% Category: Other
%
% This module e-mails the user-specified recipients about the current
% progress of the image processing modules as well as the expected time
% remaining until completion.  The user can specify how often e-mails are
% sent out (for example, after the first image set, after the last image
% set, after every X number of images, after Y images).  Note:  This
% module should be the last module loaded.  If it isn't the last module
% loaded, then the notifications are sent out after all the modules that
% are processed before this module is completed, but not before all the
% modules that comes after this module.

% CellProfiler is distributed under the GNU General Public License.
% See the accompanying file LICENSE for details.
% 
% Developed by the Whitehead Institute for Biomedical Research.
% Copyright 2003,2004,2005.
% 
% Authors:
%   Anne Carpenter <carpenter@wi.mit.edu>
%   Thouis Jones   <thouis@csail.mit.edu>
%   In Han Kang    <inthek@mit.edu>
%
% $Revision$

% PROGRAMMING NOTE
% HELP:
% The first unbroken block of lines will be extracted as help by
% CellProfiler's 'Help for this analysis module' button as well as
% Matlab's built in 'help' and 'doc' functions at the command line. It
% will also be used to automatically generate a manual page for the
% module. An example image demonstrating the function of the module
% can also be saved in tif format, using the same name as the
% module (minus Alg), and it will automatically be included in the
% manual page as well.  Follow the convention of: purpose of the
% module, description of the variables and acceptable range for each,
% how it works (technical description), info on which images can be 
% saved, and See also CAPITALLETTEROTHERMODULES. The license/author
% information should be separated from the help lines with a blank
% line so that it does not show up in the help displays.  Do not
% change the programming notes in any modules! These are standard
% across all modules for maintenance purposes, so anything
% module-specific should be kept separate.

% PROGRAMMING NOTE
% DRAWNOW:
% The 'drawnow' function allows figure windows to be updated and
% buttons to be pushed (like the pause, cancel, help, and view
% buttons).  The 'drawnow' function is sprinkled throughout the code
% so there are plenty of breaks where the figure windows/buttons can
% be interacted with.  This does theoretically slow the computation
% somewhat, so it might be reasonable to remove most of these lines
% when running jobs on a cluster where speed is important.
drawnow

%%%%%%%%%%%%%%%%
%%% VARIABLES %%%
%%%%%%%%%%%%%%%%
drawnow

% PROGRAMMING NOTE
% VARIABLE BOXES AND TEXT: 
% The '%textVAR' lines contain the text which is displayed in the GUI
% next to each variable box. The '%defaultVAR' lines contain the
% default values which are displayed in the variable boxes when the
% user loads the module. The line of code after the textVAR and
% defaultVAR extracts the value that the user has entered from the
% handles structure and saves it as a variable in the workspace of
% this module with a descriptive name. The syntax is important for
% the %textVAR and %defaultVAR lines: be sure there is a space before
% and after the equals sign and also that the capitalization is as
% shown.  Don't allow the text to wrap around to another line; the
% second line will not be displayed.  If you need more space to
% describe a variable, you can refer the user to the help file, or you
% can put text in the %textVAR line above or below the one of
% interest, and do not include a %defaultVAR line so that the variable
% edit box for that variable will not be displayed; the text will
% still be displayed. Keep in mind that you can have
% several inputs into the same box: for example, a box could be
% designed to receive two numbers separated by a comma, as long as you
% write a little extraction algorithm that separates the input into
% two distinct variables.  Any extraction algorithms like this should
% be within the VARIABLES section of the code, at the end.

%%% Reads the current module number, because this is needed to find 
%%% the variable values that the user entered.
CurrentModule = handles.Current.CurrentModuleNumber;
CurrentModuleNum = str2double(CurrentModule);

%textVAR01 = Send e-mails to these e-mail addresses #LongBox#
%defaultVAR01 = default@default.com
AddressEmail = char(handles.Settings.VariableValues{CurrentModuleNum,1});

%textVAR02 = Send e-mails from this e-mail address #LongBox#
%defaultVAR02 = youremail@address.com
AddressFrom = char(handles.Settings.VariableValues{CurrentModuleNum,2});

%textVAR03 = Enter the SMTP server
%defaultVAR03 = mail
SMTPServer = char(handles.Settings.VariableValues{CurrentModuleNum,3});

%textVAR04 = Send an e-mail after the first image set is completed?
%defaultVAR04 = Y
FirstImageEmail = char(handles.Settings.VariableValues{CurrentModuleNum,4});

%textVAR05 = Send an e-mail after the last image set is completed?
%defaultVAR05 = Y
LastImageEmail = char(handles.Settings.VariableValues{CurrentModuleNum,5});

%textVAR06 = Send an e-mail after every X number of image sets?
%defaultVAR06 = 0
EveryXImageEmail = str2double(char(handles.Settings.VariableValues{CurrentModuleNum,6}));

%textVAR07 = Send an e-mail after _ number of image sets?
%defaultVAR07 = 0
Specified1Email = str2double(char(handles.Settings.VariableValues{CurrentModuleNum,7}));

%textVAR08 = Send an e-mail after _ number of image sets?
%defaultVAR08 = 0
Specified2Email = str2double(char(handles.Settings.VariableValues{CurrentModuleNum,8}));

%textVAR09 = Send an e-mail after _ number of image sets?
%defaultVAR09 = 0
Specified3Email = str2double(char(handles.Settings.VariableValues{CurrentModuleNum,9}));

%textVAR10 = Send an e-mail after _ number of image sets?
%defaultVAR10 = 0
Specified4Email = str2double(char(handles.Settings.VariableValues{CurrentModuleNum,10}));

%textVAR11 = Send an e-mail after _ number of image sets?
%defaultVAR11 = 0
Specified5Email = str2double(char(handles.Settings.VariableValues{CurrentModuleNum,11}));

%%%VariableRevisionNumber = 01
% The variables have changed for this module.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SENDING EMAILS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setpref('Internet','SMTP_Server',SMTPServer);
setpref('Internet','E_mail',AddressFrom);

SetBeingAnalyzed = handles.Current.SetBeingAnalyzed;

numAddresses = 0
while (isempty(AddressEmail) == 0)
    numAddresses = numAddresses + 1
    [AddressTo{numAddresses} AddressEmail] = strtok(AddressEmail, ',');
end


if ( strcmp(FirstImageEmail, 'Y') & (SetBeingAnalyzed == 1))
    subject = 'CellProfiler:  First Image Set has been completed';
    sendmail(AddressTo,subject,subject);
elseif ( strcmp(LastImageEmail, 'Y') & SetBeingAnalyzed == handles.Current.NumberOfImageSets)
    subject = 'CellProfiler:  Last Image Set has been completed';
    sendmail(AddressTo,'CellProfiler Progress',subject);
elseif ( (EveryXImageEmail > 0) & ( mod(SetBeingAnalyzed,EveryXImageEmail) == 0) )
    subject = 'CellProfiler: Last Image Set has been completed';
    sendmail(AddressTo,subject,subject);
end
    

%%%%%%%%%%%%%%%%%%%%
%%% FIGURE WINDOW %%%
%%%%%%%%%%%%%%%%%%%%
drawnow

if SetBeingAnalyzed == 1
    %%% The figure window display is unnecessary for this module, so the figure
    %%% window is closed the first time through the module.
    %%% Determines the figure number.
    fieldname = ['FigureNumberForModule',CurrentModule];
    ThisAlgFigureNumber = handles.Current.(fieldname);
    %%% If the window is open, it is closed.
    if any(findobj == ThisAlgFigureNumber) == 1;
        close(ThisAlgFigureNumber)
    end
end

drawnow

%%% STANDARD HELP STATEMENTS THAT ARE UNNECESSARY FOR THIS MODULE:
% PROGRAMMING NOTE
% DISPLAYING RESULTS:
% Each module checks whether its figure is open before calculating
% images that are for display only. This is done by examining all the
% figure handles for one whose handle is equal to the assigned figure
% number for this module. If the figure is not open, everything
% between the "if" and "end" is ignored (to speed execution), so do
% not do any important calculations here. Otherwise an error message
% will be produced if the user has closed the window but you have
% attempted to access data that was supposed to be produced by this
% part of the code. If you plan to save images which are normally
% produced for display only, the corresponding lines should be moved
% outside this if statement.

% PROGRAMMING NOTE
% HANDLES STRUCTURE:
%       In CellProfiler (and Matlab in general), each independent
% function (module) has its own workspace and is not able to 'see'
% variables produced by other modules. For data or images to be shared
% from one module to the next, they must be saved to what is called
% the 'handles structure'. This is a variable, whose class is
% 'structure', and whose name is handles. Data which should be saved
% to the handles structure within each module includes: any images,
% data or measurements which are to be eventually saved to the hard
% drive (either in an output file, or using the SaveImages module) or
% which are to be used by a later module in the analysis pipeline. Any
% module which produces or passes on an image needs to also pass along
% the original filename of the image, named after the new image name,
% so that if the SaveImages module attempts to save the resulting
% image, it can be named by appending text to the original file name.
% handles.Pipeline is for storing data which must be retrieved by other modules.
% This data can be overwritten as each image set is processed, or it
% can be generated once and then retrieved during every subsequent image
% set's processing, or it can be saved for each image set by
% saving it according to which image set is being analyzed.
%       Anything stored in handles.Measurements or handles.Pipeline
% will be deleted at the end of the analysis run, whereas anything
% stored in handles.Settings will be retained from one analysis to the
% next. It is important to think about which of these data should be
% deleted at the end of an analysis run because of the way Matlab
% saves variables: For example, a user might process 12 image sets of
% nuclei which results in a set of 12 measurements ("TotalNucArea")
% stored in the handles structure. In addition, a processed image of
% nuclei from the last image set is left in the handles structure
% ("SegmNucImg"). Now, if the user uses a different module which
% happens to have the same measurement output name "TotalNucArea" to
% analyze 4 image sets, the 4 measurements will overwrite the first 4
% measurements of the previous analysis, but the remaining 8
% measurements will still be present. So, the user will end up with 12
% measurements from the 4 sets. Another potential problem is that if,
% in the second analysis run, the user runs only a module which
% depends on the output "SegmNucImg" but does not run a module
% that produces an image by that name, the module will run just
% fine: it will just repeatedly use the processed image of nuclei
% leftover from the last image set, which was left in the handles
% structure ("SegmNucImg").
%       Note that two types of measurements are typically made: Object
% and Image measurements.  Object measurements have one number for
% every object in the image (e.g. ObjectArea) and image measurements
% have one number for the entire image, which could come from one
% measurement from the entire image (e.g. ImageTotalIntensity), or
% which could be an aggregate measurement based on individual object
% measurements (e.g. ImageMeanArea).  Use the appropriate prefix to
% ensure that your data will be extracted properly.
%       Saving measurements: The data extraction functions of
% CellProfiler are designed to deal with only one "column" of data per
% named measurement field. So, for example, instead of creating a
% field of XY locations stored in pairs, they should be split into a field
% of X locations and a field of Y locations. Measurements must be
% stored in double format, because the extraction part of the program
% is designed to deal with that type of array only, not cell or
% structure arrays. It is wise to include the user's input for
% 'ObjectName' as part of the fieldname in the handles structure so
% that multiple modules can be run and their data will not overwrite
% each other.
%       Extracting measurements: handles.Measurements.CenterXNuclei{1}(2) gives
% the X position for the second object in the first image.
% handles.Measurements.AreaNuclei{2}(1) gives the area of the first object in
% the second image.