USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodePercentGetList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodePercentGetList]

	@Entity varchar(50),
	@EntityKey int


AS --Encrypt

/*
|| When      Who Rel     What
|| 03/07/08  GHL 8.5.0.6 LLNL 2008 CBCode to Project/Task conversion
*/

		SELECT cbp.*, cbc.CBCode, cbc.ProjectNumber, cbc.TaskNumber
		FROM tCBCodePercent cbp (nolock)
		inner join tCBCode cbc (nolock) on cbp.CBCodeKey = cbc.CBCodeKey
		WHERE
		Entity = @Entity and
		EntityKey = @EntityKey
		Order By cbc.CBCode

	RETURN 1
GO
