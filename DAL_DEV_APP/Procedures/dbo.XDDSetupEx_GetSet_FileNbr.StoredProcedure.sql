USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDSetupEx_GetSet_FileNbr]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[XDDSetupEx_GetSet_FileNbr]
	@Mode		varchar( 2 )		-- 'AP' - AP/Wire, 'AR' - AREFT, 'PP' - Pos Pay
as

	declare @EBFileNbr	As varchar( 6 )
	
	if @Mode = 'AP'
	BEGIN
		SELECT	@EBFileNbr = APAPONextFileNbr 
		FROM	XDDSetupEx (nolock)

   		-- Increment to the Next
		UPDATE	XDDSetupEx
		SET	APAPONextFileNbr = right('000000' + rtrim(Convert(varchar(6), Convert(int, APAPONextFileNbr) + 1)), 6)
	END

	if @Mode = 'AR'
	BEGIN
		SELECT	@EBFileNbr = ARNextFileNbr
		FROM	XDDSetupEx (nolock)

   		-- Increment to the Next
		UPDATE	XDDSetupEx
		SET	ARNextFileNbr = right('000000' + rtrim(Convert(varchar(6), Convert(int, ARNextFileNbr) + 1)), 6)
	END

	if @Mode = 'PP'
	BEGIN
		SELECT	@EBFileNbr = PPNextFileNbr
		FROM	XDDSetupEx (nolock)

   		-- Increment to the Next
		UPDATE	XDDSetupEx
		SET	PPNextFileNbr = right('000000' + rtrim(Convert(varchar(6), Convert(int, PPNextFileNbr) + 1)), 6)
	END
	
	SELECT @EBFileNbr
GO
