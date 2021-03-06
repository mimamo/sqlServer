USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_1099detail]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xvr_1099detail] as 
select vo.refnbr, vo.vendid, vo.docbal, vo.origdocamt, vo.doctype, t.boxnbr,
	amount = 
			isnull(((CASE vo.doctype
						WHEN 'AD' 
                          THEN t.tranamt*-1
					    ELSE 
                          t.tranamt
						END)/vo.origdocamt), 0)*a.adjamt,
	isNextYear = 
			isnull((CASE year(ck.docdate)
						WHEN apsetup.curr1099yr
							then 'False'
						ELSE
							'True'
						END),0),
		a.adjgrefnbr, a.adjgdoctype, ck.docdate, year(ck.docdate) as year, 
		t.cpnyid, t.acct, t.sub, t.trandesc, apsetup.curr1099yr, apsetup.next1099yr from apdoc vo
	inner join aptran t on vo.refnbr=t.refnbr and vo.doctype=t.trantype
	inner join apadjust a on vo.refnbr=a.adjdrefnbr and vo.doctype=a.adjddoctype
	inner join apdoc ck on a.adjgrefnbr=ck.refnbr and a.adjgdoctype=ck.doctype and ck.acct=a.adjgacct and ck.sub=a.adjgsub
	inner join apsetup with (nolock) on year(ck.docdate)=apsetup.curr1099yr or year(ck.docdate)=apsetup.next1099yr
	where vo.doctype in ('VO','AC','AD','PP') and t.boxnbr<>''
GO
