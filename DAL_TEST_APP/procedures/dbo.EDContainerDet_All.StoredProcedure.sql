USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_All]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainerDet_All] @CpnyId varchar(10), @ContainerId varchar(10), @LineNbrMin smallint, @LineNbrMax smallint As
Select * From EDContainerDet Where CpnyId = @CpnyId And ContainerId = @ContainerId And LineNbr Between @LineNbrMin And @LineNbrMax
GO
