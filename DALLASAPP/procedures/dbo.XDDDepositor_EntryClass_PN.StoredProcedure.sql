USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDDepositor_EntryClass_PN]    Script Date: 12/21/2015 13:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDDepositor_EntryClass_PN]
	@VendCust	varchar(1),
	@FormatID	varchar(15),
	@parm1 		varchar(4),
	@parm2 		varchar(1)

AS
  	Select 		*
  	from 		XDDDepositor
  	where 		VendCust = @VendCust
  			and FormatID = @FormatID
  			and EntryClass LIKE @parm1
  			and PNStatus LIKE @parm2
  	ORDER by 	EntryClass, VendID
GO
