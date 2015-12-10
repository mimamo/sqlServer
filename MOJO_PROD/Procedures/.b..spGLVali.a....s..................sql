USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLValidatePost]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGLValidatePost]
(
	@Entity varchar(50),
	@EntityKey int
)

AS --Encrypt

Declare @TotalDebit money
Declare @TotalCredit money

Select @TotalDebit = ISNULL(Sum(Debit), 0), @TotalCredit = ISNULL(Sum(Credit), 0)
from tTransaction (nolock)
Where
	Entity = @Entity and
	EntityKey = @EntityKey

If @TotalDebit <> @TotalCredit
	return -1
else
	return 1
GO
