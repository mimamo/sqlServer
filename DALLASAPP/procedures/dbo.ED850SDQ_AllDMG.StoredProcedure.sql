USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_AllDMG]    Script Date: 12/21/2015 13:44:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ED850SDQ_All    Script Date: 5/28/99 1:17:39 PM ******/
CREATE Proc [dbo].[ED850SDQ_AllDMG] @Parm1 varchar(10), @Parm2 varchar(10), @Parm3 smallint, @Parm4 smallint As
Select * From ED850SDQ Where CpnyId = @Parm1 And EDIPOID = @Parm2 And LineNbr Between @Parm3 And @Parm4
GO
