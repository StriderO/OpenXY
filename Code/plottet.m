% to plot tetragonality line scan data from analysis parameters - first load mat file

% RefEuler=Settings.NewAngles(Settings.RefInd(1),:);
% g=euler2gmat(RefEuler(1),RefEuler(2),RefEuler(3));

if isfield(Settings,'ScanLength')
    NN = Settings.ScanLength;
else
    NN = length(Settings.ImageNamesList);
end
tempF=zeros(3);
for i=1:NN
     tempF(:,:)=Settings.data.F(:,:,i);
%      tempF(:,:)=Settings.data.F{i}; % old data types
RefEuler=Settings.NewAngles(NN,:);
g=euler2gmat(RefEuler(1),RefEuler(2),RefEuler(3));
    tempF=g'*tempF*g; % rotate from crystal to sample frame
    [tempR tempU]=poldec(tempF);
    temptet(i)=tempU(3,3)-(tempU(1,1)+tempU(2,2))/2;
    tempU=tempU-eye(3);
    u33(i)=tempU(3,3); 
    u22(i)=tempU(2,2);
    u11(i)=tempU(1,1);
end

figure; plot([1:NN],u11*100,'r',[1:NN],u22*100,'g',[1:NN],u33*100)
grid on
set(gca,'fontsize',16)
xlabel('Scan position (\mum)')
ylabel('Strain (%)')
%axis([0 NN -1.5 1]);
legend('\epsilon_1_1','\epsilon_2_2','\epsilon_3_3')


figure;plot(temptet*100)
grid on
set(gca,'fontsize',16)
xlabel('Scan position (\mum)')
ylabel('Tetragonality (%)')
axis([0 NN -0.5 2]);
msgbox('Note that tetragonality plot assumes elongation in z direction');
