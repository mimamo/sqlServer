USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_WORequest_Delete]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[SCM_WORequest_Delete]
	@CpnyID		varchar( 10 ),
	@OrdNbr		varchar( 15 ),
	@LineRef	varchar( 5 )
	AS
	DELETE		WORequest
	WHERE		CpnyID = @CpnyID and
			OrdNbr = @OrdNbr and
			LineRef = @LineRef
GO
