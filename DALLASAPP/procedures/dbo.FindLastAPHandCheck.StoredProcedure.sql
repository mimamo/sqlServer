USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[FindLastAPHandCheck]    Script Date: 12/21/2015 13:44:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FindLastAPHandCheck    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[FindLastAPHandCheck] @parm1 varchar ( 10), @parm2 varchar ( 24) As
Select CASE WHEN MAX(APDoc.RefNbr) IS null then "0" ELSE MAX(APDoc.RefNbr) END from APDoc
Where APDoc.DocClass = 'C' And
APDoc.Acct = @parm1 AND
APDoc.Sub = @parm2
GO
