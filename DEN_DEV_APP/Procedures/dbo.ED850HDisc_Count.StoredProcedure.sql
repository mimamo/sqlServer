USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HDisc_Count]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850HDisc_Count] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select Count(*) From ED850HDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
