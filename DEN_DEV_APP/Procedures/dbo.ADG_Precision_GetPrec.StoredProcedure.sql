USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Precision_GetPrec]    Script Date: 12/21/2015 14:05:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Precision_GetPrec]
as

	If (select Count(*) from INSetup (NOLOCK)) > 0 and (Select Count(*) from SOSetup (NOLOCK)) > 0
	select	i.DecPlPrcCst,
		i.DecPlQty,
		s.DecPlNonStdQty
	from	INSetup i (NOLOCK),
		SOSetup s (NOLOCK)

	If (select Count(*) from INSetup (NOLOCK)) > 0 and (Select Count(*) from SOSetup (NOLOCK)) = 0
	select	i.DecPlPrcCst,
		i.DecPlQty,
		Convert(smallint, 9) DecPlNonStdQty
	from	INSetup i (NOLOCK)

	If (select Count(*) from INSetup (NOLOCK)) = 0 and (Select Count(*) from SOSetup (NOLOCK)) > 0
	select	Convert(smallint, 9) DecPlPrcCst,
		Convert(smallint, 9) DecPlQty,
		s.DecPlNonStdQty
	from	SOSetup s (NOLOCK)

	If (select Count(*) from INSetup (NOLOCK)) = 0 and (Select Count(*) from SOSetup (NOLOCK)) = 0
		If (select Count(*) from POSetup (NOLOCK)) > 0
		select	DecPlPrcCst,
			DecPlQty,
			Convert(smallint, 9) DecPlNonStdQty
		from	POSetup p (NOLOCK)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
