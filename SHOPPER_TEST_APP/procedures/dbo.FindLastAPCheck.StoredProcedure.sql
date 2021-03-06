USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FindLastAPCheck]    Script Date: 12/21/2015 16:07:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FindLastAPCheck    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[FindLastAPCheck] @parm1 varchar ( 10), @parm2 varchar ( 24) As
Select ISNULL(MAX(refnbr) ,'0')
FROM APDoc a (NOLOCK)
Where a.DocClass = 'C'
AND a.Acct = @parm1
AND a.Sub = @parm2
AND
(a.DocType in ('CK', 'MC', 'SC', 'ZC')
OR
((a.DocType = 'VC')
 AND NOT EXISTS (SELECT 1 FROM APDoc b (NOLOCK) WHERE a.refnbr = b.refnbr AND a.VendId = b.VendId and a.Acct = b.Acct and a.Sub = b.Sub and b.DocType = 'HC')))
GO
