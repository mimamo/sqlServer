USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_UpdateUOM]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_UpdateUOM] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @UOM varchar(6) As
Update ED850SDQ Set UOM = @UOM Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
GO
