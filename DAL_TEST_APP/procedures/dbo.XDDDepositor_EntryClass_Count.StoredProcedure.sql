USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDDepositor_EntryClass_Count]    Script Date: 12/21/2015 13:57:19 ******/
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
