% code to localize subdural eeg and stereo eeg electrodes
%   Created by:
%
%     Copyright (C) 2009  D. Hermes, Dept of Neurology and Neurosurgery, University Medical Center Utrecht
%                   2019  D. van Blooijs, Dept of Neurology and Neurosurgery, University Medical Center Utrecht

%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
% DvB - made it usable with BIDS electrodes.tsv September 2019

%%
% make sure SPM functions are in your path
addpath(genpath('/home/dorien/Desktop/git_rep/Paper_Hermes_2010_JNeuroMeth/'))

%% 1) run segment anatomical MR in SPM5
% startup SPM (spm functions are used)
% segment MR in freesurfer

%% 2) generate surface (The Hull) to project electrodes to
% only for ECoG

%% 3) select electrodes from ct
ctmr
% view result
% save image: saves as nifti hdr and img files

%% 4) sort unprojected electrodes
% open electrodes.tsv
elec_input = '/Fridge/CCEP/';

[filename, pathname] = uigetfile('*.tsv;*.tsv','Select electroces.tsv file',elec_input);

tb_elecs = readtable(fullfile(pathname,filename),'FileType','text','Delimiter','\t');

sortElectrodes(tb_elecs, fullfile(pathname,filename));
% loads img file with electrodes from previous step
% saves as electrodes_locX;


%% 5) plot electrodes 2 surface
% electrodes2surf(subject,localnorm index,do not project electrodes closer than 3 mm to surface)

%% 6) combine electrode files into one and make an image
%
elecmatrix=nan(126,3);

a = load('/home/dorien/Desktopelectrodes_loc1.mat'); %
elecmatrix(1:64,:) = a.elecmatrix;
a = load('/home/dorien/Desktopelectrodes_loc2.mat'); %
elecmatrix(65:90,:) = a.elecmatrix;
a = load('/home/dorien/Desktopelectrodes_loc3.mat'); %
elecmatrix(97:126,:) = a.elecmatrix;

save('/home/dorien/Desktop/Fransen_elecmatrix','elecmatrix')

%% 7) ?
    [output,els,els_ind,outputStruct]=position2reslicedImage(elecmatrix,'./data_freesurfer/name_t1.nii');

    for filenummer=1:100
        save(['./data/' subject '_electrodes_surface_loc_all' int2str(filenummer) '.mat'],'elecmatrix');
        outputStruct.fname=['./data/electrodes_surface_all' int2str(filenummer) '.img' ];
        if ~exist(outputStruct.fname,'file')>0
            disp(['saving ' outputStruct.fname]);
            % save the data
            spm_write_vol(outputStruct,output);
            break
        end
    end




