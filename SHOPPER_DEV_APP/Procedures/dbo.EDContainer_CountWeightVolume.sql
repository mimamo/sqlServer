USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_CountWeightVolume]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_CountWeightVolume] @CpnyId varchar(10), @ShipperId varchar(10) As
Select Sum(Weight), Min(WeightUOM), Max(WeightUOM), Sum(Volume), Min(VolumeUOM), Max(VolumeUOM),
Min(PackMethod), Max(PackMethod), Count(*), Sum(ShpWeight) From EDContainer Where
CpnyId = @CpnyId And ShipperId = @ShipperId And TareFlag = 0
GO
