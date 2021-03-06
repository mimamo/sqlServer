USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vp_24630Docs]    Script Date: 12/21/2015 14:33:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vp_24630Docs] as
select r.ri_id, d.cpnyid, d.curyid, d.doctype, d.refnbr, d.custid, vendid=' ', d.status, d.curyrate, d.curymultdiv, 
CuryPmtAmt = round(case when d.discdate>= r.reportdate then d.curydocbal - d.curydiscbal else d.curydocbal end, c.decpl), 
CalcRate = r.rate, CalcMultDiv = r.multdiv,
OrigBasePmtAmt = round( case when d.curymultdiv = 'M' then case when d.discdate >=r.reportdate then convert(dec(28,3), d.curydocbal) - convert(dec(28,3), d.curydiscbal) else convert(dec(28,3), d.curydocbal) end * convert(dec(19,9), d.curyrate)
			else case when d.discdate >=r.reportdate then convert(dec(28,3), d.curydocbal) - convert(dec(28,3), d.curydiscbal) else convert(dec(28,3), d.curydocbal) end / convert(dec(19,9), d.curyrate) end, b.decpl),				
CalcBasePmtAmt = round(	case when r.multdiv = 'M' then case when d.discdate >=r.reportdate then convert(dec(28,3), d.curydocbal) - convert(dec(28,3), d.curydiscbal) else convert(dec(28,3), d.curydocbal) end * convert(dec(19,9), r.rate)
			else case when d.discdate >=r.reportdate then convert(dec(28,3), d.curydocbal) - convert(dec(28,3), d.curydiscbal) else convert(dec(28,3), d.curydocbal) end / convert(dec(19,9), r.rate) end, b.decpl),
UnrlGainAcct = coalesce(o.UnrlGainAcct, c.UnrlGainAcct),
UnrlGainSub = coalesce(o.UnrlGainSub, c.UnrlGainSub),
UnrlLossAcct = coalesce(o.UnrlLossAcct, c.UnrlLossAcct),
UnrlLossSub = coalesce(o.UnrlLossSub, c.UnrlLossSub)
from 
ardoc d 
inner join currncy c on d.curyid = c.curyid
inner join vp_ShareRptCuryRate r on d.curyid = r.fromcuryid and d.curyratetype = r.ratetype
inner join rptruntime u on r.ri_id = u.ri_id and d.cpnyid = u.cpnyid
inner join currncy b on r.tocuryid = b.curyid
left join CuryAcTb o on d.curyid = o.curyid and d.bankacct = o.adjacct
inner join vs_rptcontrol rc on u.reportnbr = rc.reportnbr
where
rtrim(u.reportformat) = rtrim(rc.reportformat01) 
and d.doctype in ('FI', 'IN', 'DM', 'CM')
and d.opendoc = 1
and d.rlsed = 1

union all

select r.ri_id, d.cpnyid, d.curyid, d.doctype, d.refnbr, ' ', d.vendid, d.status, d.curyrate, d.curymultdiv, 
round(case when d.discdate>= r.reportdate then d.curydocbal - d.curydiscbal else d.curydocbal end, c.decpl), 
r.rate, r.multdiv,
round( case when d.curymultdiv = 'M' then case when d.discdate >=r.reportdate then convert(dec(28,3), d.curydocbal) - convert(dec(28,3), d.curydiscbal) else convert(dec(28,3), d.curydocbal) end * convert(dec(19,9), d.curyrate)
			else case when d.discdate >=r.reportdate then convert(dec(28,3), d.curydocbal) - convert(dec(28,3), d.curydiscbal) else convert(dec(28,3), d.curydocbal) end / convert(dec(19,9), d.curyrate) end, b.decpl),				
round(	case when r.multdiv = 'M' then case when d.discdate >=r.reportdate then convert(dec(28,3), d.curydocbal) - convert(dec(28,3), d.curydiscbal) else convert(dec(28,3), d.curydocbal) end * convert(dec(19,9), r.rate)
			else case when d.discdate >=r.reportdate then convert(dec(28,3), d.curydocbal) - convert(dec(28,3), d.curydiscbal) else convert(dec(28,3), d.curydocbal) end / convert(dec(19,9), r.rate) end, b.decpl),
coalesce(o.UnrlGainAcct, c.UnrlGainAcct),
coalesce(o.UnrlGainSub, c.UnrlGainSub),
coalesce(o.UnrlLossAcct, c.UnrlLossAcct),
coalesce(o.UnrlLossSub, c.UnrlLossSub)
from 
apdoc d 
inner join currncy c on d.curyid = c.curyid
inner join vp_ShareRptCuryRate r on d.curyid = r.fromcuryid and d.curyratetype = r.ratetype
inner join rptruntime u on r.ri_id = u.ri_id and d.cpnyid = u.cpnyid
inner join currncy b on r.tocuryid = b.curyid
left join CuryAcTb o on d.curyid = o.curyid and d.acct = o.adjacct
inner join vs_rptcontrol rc on u.reportnbr = rc.reportnbr
where
rtrim(u.reportformat) = rtrim(rc.reportformat00) 
and d.doctype  in ('AC', 'AD', 'VO')
and d.opendoc  =  1
and d.rlsed    =  1
and d.selected = 0
GO
