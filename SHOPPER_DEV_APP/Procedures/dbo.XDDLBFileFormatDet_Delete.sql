USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDLBFileFormatDet_Delete]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDLBFileFormatDet_Delete]
   @FormatID	varchar(15)
   

AS
   DELETE
   FROM         XDDLBFileFormatDet
   WHERE        FormatID = @FormatID
GO
