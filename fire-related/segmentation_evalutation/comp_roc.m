function [ precision recall fmeas overseg underseg true_pos_rt false_pos_rt] = comp_roc( assoc_arr_man, assoc_arr_auto, len_arr_man, len_arr_auto )
%Compute:
%precision = TP/(TP+FP) %where all segmented fibers actual fibers?
%recall = TP/(TP+FN) %where all actual fibers segmented?
%Fmeas = 2*(precision*recall)/(precision + recall)
%OVS = oversegmentation rate (# of manual fibers associated with more than
%one segmented fiber/# of manual fibers associcated)
%UNS = undersegmentation rate (# of segmented fibers associated with more
%than one manual fiber/# of segmented fibers associated)

%# of actual fibers with associations TP (hits)
TP = nansum(assoc_arr_man > 0);

%# of actual fibers without associations FN (misses)
FN = nansum(assoc_arr_man == 0);

%# of segmented fibers that don't seem to match any real fibers FP (false alarms)
FP = nansum(assoc_arr_auto == 0);

%# of manual fibers associated with more than one segmented fiber
over = nansum(assoc_arr_man > 1);

%# of segmented fibers associated with more than one manual fiber
under = nansum(assoc_arr_auto > 1);
auto_tot = nansum(assoc_arr_auto > 0);

precision = NaN;
recall = NaN;
fmeas = NaN;
overseg = NaN;
underseg = NaN;
true_pos_rt = NaN;
false_pos_rt = NaN;


if (TP + FP) ~= 0
    precision = TP/(TP+FP);
end

if (TP + FN) ~= 0
    recall = TP/(TP+FN);
end

if (precision + recall) ~= 0
    fmeas = 2*(precision * recall)/(precision + recall);
end

if TP ~= 0
    overseg = over/TP;
end

if auto_tot ~= 0
    underseg = under/auto_tot;
end

%now compute values based on pixel counting
%compute the length of all of the correctly segmented fibers
Np = 128*128;
TPp = nansum(len_arr_man(assoc_arr_man>0));
FNp = nansum(len_arr_man(assoc_arr_man==0));
FPp = nansum(len_arr_auto(assoc_arr_auto==0));
TNp = Np - TPp - FNp - FPp;

if (TPp + FNp) ~= 0
    true_pos_rt = TPp/(TPp + FNp);
end

if (FPp + TNp) ~= 0
    false_pos_rt = FPp/(FPp + TNp);
end



end

