USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HeaderExt_AllDMG]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ED850HeaderExt_All    Script Date: 5/28/99 1:17:38 PM ******/
CREATE Proc [dbo].[ED850HeaderExt_AllDMG] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select * From ED850HeaderExt Where CpnyId = @CpnyID And EDIPOID = @EDIPOID
GO
