USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDLBFileFormatDet_All]    Script Date: 12/21/2015 16:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDLBFileFormatDet_All]
   @FormatID	varchar(15),
   @LineNbrBeg	smallint,
   @LineNbrEnd	smallint
   

AS
   SELECT       *
   FROM         XDDLBFileFormatDet
   WHERE        FormatID LIKE @FormatID
   		and LineNbr Between @LineNbrBeg and @LineNbrEnd
   ORDER BY     FormatID, LineNbr
GO
