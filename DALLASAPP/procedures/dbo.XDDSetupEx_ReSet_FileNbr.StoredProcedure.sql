USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDSetupEx_ReSet_FileNbr]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[XDDSetupEx_ReSet_FileNbr]
	@Mode		varchar( 2 ),		-- 'AP' - AP/Wire, 'AR' - AREFT, 'PP' - Pos Pay
	@OrigEBNbr	varchar( 6 )
as

	if @Mode = 'AP'
	BEGIN
		if (Select convert(int, APAPONextFileNbr) FROM XDDSetupEx (nolock)) = convert(int, @OrigEBNbr) + 1
		BEGIN
	   		-- Restore to Original Number
			UPDATE	XDDSetupEx
			SET	APAPONextFileNbr = @OrigEBNbr
		END
	END

	if @Mode = 'AR'
	BEGIN
		if (Select convert(int, ARNextFileNbr) FROM XDDSetupEx (nolock)) = convert(int, @OrigEBNbr) + 1
		BEGIN
	   		-- Restore to Original Number
			UPDATE	XDDSetupEx
			SET	ARNextFileNbr = @OrigEBNbr
		END
	END

	if @Mode = 'PP'
	BEGIN
		if (Select convert(int, PPNextFileNbr) FROM XDDSetupEx (nolock)) = convert(int, @OrigEBNbr) + 1
		BEGIN
	   		-- Restore to Original Number
			UPDATE	XDDSetupEx
			SET	PPNextFileNbr = @OrigEBNbr
		END
	END
GO
