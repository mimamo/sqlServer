USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnType_By_EStatus]    Script Date: 12/21/2015 16:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTxnType_By_EStatus]
   @FormatID	varchar(15),
   @EStatus	varchar(1)

AS
   SELECT       *
   FROM		XDDTxnType
   WHERE	FormatID = @FormatID
   		and EStatus LIKE @EStatus
   ORDER BY	FormatID, EStatus
GO
