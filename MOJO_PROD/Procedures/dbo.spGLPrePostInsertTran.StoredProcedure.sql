USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPrePostInsertTran]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPrePostInsertTran]

	(
		@CompanyKey int,
		@Type char(1),
		@TransactionDate smalldatetime,
		@Entity varchar(50),
		@EntityKey int,
		@Reference varchar(100),
		@GLAccountKey int,
		@Amount money,
		@ClassKey int,
		@Memo varchar(500),
		@ProjectKey int,
		@SourceCompanyKey int
	)

AS --Encrypt

/*
Create Table #PrePost (
	CompanyKey int,
	TransactionDate smalldatetime,
	Entity varchar(50),
	EntityKey int,
	Reference varchar(100),
	GLAccountKey int,
	ClassKey
	Debit money,
	Credit money,
	Memo varchar(500),
	ProjectKey int,
	SourceCompanyKey int
)
*/

IF @Type = 'D'

	INSERT #PrePost
			(
			CompanyKey,
			TransactionDate,
			Entity,
			EntityKey,
			Reference,
			GLAccountKey,
			Debit,
			Credit,
			ClassKey,
			Memo,
			ProjectKey,
			SourceCompanyKey
			)

		VALUES
			(
			@CompanyKey,
			@TransactionDate,
			@Entity,
			@EntityKey,
			@Reference,
			@GLAccountKey,
			Round(@Amount, 2),
			0,
			@ClassKey,
			@Memo,
			@ProjectKey,
			@SourceCompanyKey
			)
else
	INSERT #PrePost
			(
			CompanyKey,
			TransactionDate,
			Entity,
			EntityKey,
			Reference,
			GLAccountKey,
			Debit,
			Credit,
			ClassKey,
			Memo,
			ProjectKey,
			SourceCompanyKey
			)

		VALUES
			(
			@CompanyKey,
			@TransactionDate,
			@Entity,
			@EntityKey,
			@Reference,
			@GLAccountKey,
			0,
			Round(@Amount, 2),
			@ClassKey,
			@Memo,
			@ProjectKey,
			@SourceCompanyKey
			)
GO
