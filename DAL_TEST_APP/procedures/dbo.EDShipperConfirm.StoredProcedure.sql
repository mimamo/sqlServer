USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipperConfirm]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipperConfirm] @CpnyId varchar(10), @ShipperId varchar(15) As
Declare @ManifestUpdated smallint
EXEC EDContainer_UpdateManifest @CpnyId, @ShipperId, @ManifestUpdated output
Select @ManifestUpdated
GO
