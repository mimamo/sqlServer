USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Acct_Sub_Cpny_DocType_RefNbr]    Script Date: 12/21/2015 13:44:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Acct_Sub_Cpny_DocType_RefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[Acct_Sub_Cpny_DocType_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar ( 10), @parm4 varchar (10) as
Select * from APDoc where Acct = @parm1
and Sub = @parm2
and CpnyID LIKE @parm3
and DocType in ('HC', 'CK', 'ZC')
and Status Not In ('V')
and Rlsed = 1
and RefNbr like @parm4
order by Acct, Sub, DocType, RefNbr
GO
