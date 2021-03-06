USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_OU_AutoGeneratePO]    Script Date: 12/21/2015 15:42:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_OU_AutoGeneratePO]
	@CpnyID as varchar(10),
	@SOTypeID as varchar(4),
	@GeneratesPOs as smallint OUTPUT
as
	if exists
		(select CpnyID
		from SOStep (NOLOCK)
		where CpnyID = @CpnyID
			and SOTypeID = @SOTypeID
			and FunctionID = '6040000')

		set @GeneratesPOs = 1
	else
		set @GeneratesPOs = 0

	return 1 --Success
GO
