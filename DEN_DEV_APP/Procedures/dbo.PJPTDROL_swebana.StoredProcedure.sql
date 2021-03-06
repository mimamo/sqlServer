USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_swebana]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_swebana] @parm1 varchar (16), @parm2 varchar (4)  as

select pjptdrol.acct, pjptdrol.eac_amount, pjptdrol.eac_units, pjacct.acct_type, pjacct.sort_num, 
pjactrol.amount_01 acta01, pjactrol.amount_02 acta02, pjactrol.amount_03 acta03, pjactrol.amount_04 acta04, pjactrol.amount_05 acta05, pjactrol.amount_06 acta06,
pjactrol.amount_07 acta07, pjactrol.amount_08 acta08, pjactrol.amount_09 acta09, pjactrol.amount_10 acta10, pjactrol.amount_11 acta11, pjactrol.amount_12 acta12,
pjactrol.amount_13 acta13, pjactrol.amount_14 acta14, pjactrol.amount_15 acta15, pjactrol.amount_bf actabf, 
pjactrol.units_01 actu01, pjactrol.units_02 actu02, pjactrol.units_03 actu03, pjactrol.units_04 actu04, pjactrol.units_05 actu05, pjactrol.units_06 actu06,
pjactrol.units_07 actu07, pjactrol.units_08 actu08, pjactrol.units_09 actu09, pjactrol.units_10 actu10, pjactrol.units_11 actu11, pjactrol.units_12 actu12,
pjactrol.units_13 actu13, pjactrol.units_14 actu14, pjactrol.units_15 actu15, pjactrol.units_bf actubf, 

pjcomrol.amount_01 coma01, pjcomrol.amount_02 coma02, pjcomrol.amount_03 coma03, pjcomrol.amount_04 coma04, pjcomrol.amount_05 coma05, pjcomrol.amount_06 coma06,
pjcomrol.amount_07 coma07, pjcomrol.amount_08 coma08, pjcomrol.amount_09 coma09, pjcomrol.amount_10 coma10, pjcomrol.amount_11 coma11, pjcomrol.amount_12 coma12,
pjcomrol.amount_13 coma13, pjcomrol.amount_14 coma14, pjcomrol.amount_15 coma15, pjcomrol.amount_bf comabf, 
pjcomrol.units_01 comu01, pjcomrol.units_02 comu02, pjcomrol.units_03 comu03, pjcomrol.units_04 comu04, pjcomrol.units_05 comu05, pjcomrol.units_06 comu06,
pjcomrol.units_07 comu07, pjcomrol.units_08 comu08, pjcomrol.units_09 comu09, pjcomrol.units_10 comu10, pjcomrol.units_11 comu11, pjcomrol.units_12 comu12,
pjcomrol.units_13 comu13, pjcomrol.units_14 comu14, pjcomrol.units_15 comu15, pjcomrol.units_bf comubf 

from  pjptdrol 
JOIN pjacct on pjptdrol.acct = pjacct.acct 
LEFT OUTER JOIN pjactrol on pjptdrol.project = pjactrol.project and pjptdrol.acct = pjactrol.acct and pjactrol.fsyear_num = @parm2
LEFT OUTER JOIN pjcomrol on pjptdrol.project = pjcomrol.project and pjptdrol.acct = pjcomrol.acct and pjcomrol.fsyear_num = @parm2

where  pjptdrol.project = @parm1 and
      (pjacct.acct_type = "RV" or
       pjacct.acct_type = "EX")

order by pjacct.sort_num, pjptdrol.acct
GO
