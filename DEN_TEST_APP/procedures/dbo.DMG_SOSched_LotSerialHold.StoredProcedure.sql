USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOSched_LotSerialHold]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOSched_LotSerialHold]
	@CpnyID as varchar(10),
	@OrdNbr as varchar(10) as

if exists(select * from SOSched where CpnyID = @CpnyID and OrdNbr = @OrdNbr and LotSerialEntered < LotSerialReq)
	select convert(smallint, 1)
else
	select convert(smallint, 0)
GO
