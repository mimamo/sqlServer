USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutUpdate]
	@LayoutKey int,
	@CompanyKey int,
	@LayoutName varchar(500),
	@Entity varchar(50),
	@Active tinyint,
	@TaskDetailOption smallint,
	@TaskShowTransactions tinyint,
	@EstLineFormat smallint = 1 -- 1 By Task, 2 By Service, used on estimates when By Task/Service
AS

/*
|| When      Who Rel      What
|| 1/4/10    CRG 10.5.1.6 Created
|| 3/20/10   GWG 10.5.2.0 Added Task Detail Option
|| 10/28/10  GHL 10.5.3.7 Added Task Show Transactions Option
|| 06/16/11  GHL 10.5.4.5 (111334) Added EstLineFormat (replaces tEstimate.LineFormat)
*/

	IF @LayoutKey > 0
	BEGIN
		UPDATE	tLayout
		SET		CompanyKey = @CompanyKey,
				LayoutName = @LayoutName,
				Entity = @Entity,
				Active = @Active,
				TaskDetailOption = @TaskDetailOption,
				TaskShowTransactions = @TaskShowTransactions,
				EstLineFormat = isnull(@EstLineFormat, 1) -- By Task vs Service
		WHERE	LayoutKey = @LayoutKey
		
		RETURN @LayoutKey
	END
	ELSE
	BEGIN
		INSERT	tLayout
				(CompanyKey,
				LayoutName,
				Entity,
				TaskDetailOption,
				TaskShowTransactions,
				EstLineFormat,
				Active)
		VALUES	(@CompanyKey,
				@LayoutName,
				@Entity,
				@TaskDetailOption,
				@TaskShowTransactions,
				isnull(@EstLineFormat, 1), -- By Task vs Service
 				@Active)
				
		RETURN @@IDENTITY
	END
GO
