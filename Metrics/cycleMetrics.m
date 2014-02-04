function [  ] = cycleMetrics( L_complete_cycles, R_complete_cycles, frames_per_second, L_data, R_data )
% Takes complete gait cycles as returned by findCompleteCycles.  This is a
% matrix where each row contains the frame indices of the phase boundaries
% of a complete gait cycle.  Outputs metrics like the cycle time and steps
% per minute.

L_average_frames_per_cycle = mean( diff(L_complete_cycles(:,1)) );
R_average_frames_per_cycle = mean( diff(R_complete_cycles(:,1)) );

L_average_cycle_time = L_average_frames_per_cycle / frames_per_second
R_average_cycle_time = R_average_frames_per_cycle / frames_per_second

L_steps_per_minute = 60 / L_average_cycle_time
R_steps_per_minute = 60 / R_average_cycle_time

L_average_swing_phase_frames = mean( L_complete_cycles(:,4) - L_complete_cycles(:,2) )
R_average_swing_phase_frames = mean( R_complete_cycles(:,4) - R_complete_cycles(:,2) )

L_swing_to_stance_ratio = L_average_swing_phase_frames / L_average_frames_per_cycle
R_swing_to_stance_ratio = R_average_swing_phase_frames / R_average_frames_per_cycle

L_individual_phase_lengths = diff( [L_complete_cycles [L_complete_cycles(2:end,1); NaN]], 1, 2);
R_individual_phase_lengths = diff( [R_complete_cycles [R_complete_cycles(2:end,1); NaN]], 1, 2);

L_average_phase_lengths = nanmean( L_individual_phase_lengths );
R_average_phase_lengths = nanmean( R_individual_phase_lengths );

L_average_phase_amplitudes = average_gait_phase_amplitudes(L_data, L_complete_cycles);
R_average_phase_amplitudes = average_gait_phase_amplitudes(R_data, R_complete_cycles);


[~, L_Thigh_PCs] = princomp(L_data(:,4:6));
[~, R_Thigh_PCs] = princomp(R_data(:,4:6));

L_THIGH_average_phase_amplitudes = average_gait_phase_amplitudes(L_Thigh_PCs(:,1), L_complete_cycles);
R_THIGH_average_phase_amplitudes = average_gait_phase_amplitudes(R_Thigh_PCs(:,1), R_complete_cycles);

all_phase_length_ratios = [ (L_average_phase_lengths ./ sum( L_average_phase_lengths ))' (R_average_phase_lengths ./ sum( R_average_phase_lengths ))'];
all_phase_amplitude_ratios = [ (L_average_phase_amplitudes ./ sum( L_average_phase_amplitudes ))' (R_average_phase_amplitudes ./ sum( R_average_phase_amplitudes ))'];
thigh_phase_amplitude_ratios = [ (L_THIGH_average_phase_amplitudes ./ sum( L_THIGH_average_phase_amplitudes ))' (R_THIGH_average_phase_amplitudes ./ sum( R_THIGH_average_phase_amplitudes ))'];

createBarPlot( all_phase_length_ratios, 'Gait Phase Length Ratios for each leg' )
createBarPlot( all_phase_amplitude_ratios, 'Gait Phase Amplitude Ratios for each leg' )
createBarPlot( thigh_phase_amplitude_ratios, 'Gait Phase Amplitude Ratios for each Thigh' )

end

function amplitudes = average_gait_phase_amplitudes(data, complete_cycles)

    T = complete_cycles';
    Z = zeros(size(complete_cycles))';
    Z(end) = NaN;

    for i = 1 : numel(complete_cycles)-1
        phase_data = data( T(i):T(i+1), : );
        Z(i) = sum (sqrt( sum(phase_data.^2,2) ) );  
    end

    amplitudes = nanmean(Z');
    
end

function createBarPlot(LR_phase_ratios, title_string)
%createBarPlot(LR_phase_ratios)
%  LR_phase_ratios:  bar matrix data

    % Create figure
    figure1 = figure;

    % Create axes
    axes1 = axes('Parent',figure1,...
        'XTickLabel',{'Heel-off to Toe-off','Toe-off to Midswing','Midswing to Heel-strike','Heel-strike to Toe-down','Toe-down to Midstance','Midstance to Heel-off'},...
        'XTick',[1 2 3 4 5 6],...
        'FontSize',10);
    box(axes1,'on');
    hold(axes1,'all');

    % Create multiple lines using matrix input to bar
    bar1 = bar(LR_phase_ratios,'Parent',axes1);
    set(bar1(1),'DisplayName','Left leg');
    set(bar1(2),'DisplayName','Right leg');

    % Create xlabel
    xlabel('Phase','FontSize',16);

    % Create ylabel
    ylabel('Ratio of Phase to Complete Cycle','FontSize',16);

    % Create title
    title(title_string,'FontSize',16);

    % Create legend
    legend(axes1,'show',16);
end

