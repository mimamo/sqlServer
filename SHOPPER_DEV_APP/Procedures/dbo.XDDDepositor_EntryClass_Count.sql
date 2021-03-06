USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDDepositor_EntryClass_Count]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDDepositor_EntryClass_Count]
	@VendCust	varchar( 1 ),
	@FormatID	varchar( 15 ),
	@EntryClass	varchar( 4 )

AS
  	Select 		count(*)
  	from 		XDDDepositor (nolock)
  	where 		VendCust = @VendCust
  			and FormatID = @FormatID
  			and EntryClass LIKE @EntryClass
GO
