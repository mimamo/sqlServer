USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_AllDMG]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Header_AllDMG] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select * From ED850Header Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
