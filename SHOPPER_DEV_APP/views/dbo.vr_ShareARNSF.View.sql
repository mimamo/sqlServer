USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vr_ShareARNSF]    Script Date: 12/21/2015 14:33:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vr_ShareARNSF] AS

select 
v.*,

HoldRP = (Case when (v.doctype = 'PA' 
                           and exists (select 'x'
                                         from aradjust j 
                                        where v.adjdrefnbr = j.adjdrefnbr 
                                          and v.refnbr     = j.adjgrefnbr
                                          and j.adjgdoctype = 'RP' 
                                          and v.custid = j.custid))  
                   then 'RP' else 'oo' end),

HoldNSF = (Case when (v.doctype = 'PA' 
                           and exists (select 'x'
                                         from aradjust j INNER JOIN ARDoc d ON j.S4Future11=d.BatNbr
                                        where v.adjdrefnbr = j.adjdrefnbr 
                                          and v.refnbr     = j.adjgrefnbr
                                          and j.adjgdoctype = 'RP' AND d.DocType='NS' 
                                          and v.custid = j.custid))  
                   then 'NS' else 'oo' end)

from vr_Sharearcustdetail v
where v.doctype <> 'VT'
GO
