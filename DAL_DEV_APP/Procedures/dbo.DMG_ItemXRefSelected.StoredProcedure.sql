USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemXRefSelected]    Script Date: 12/21/2015 13:35:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ItemXRefSelected]
	@AlternateID	varchar(30),
	@EntityID	varchar(15),
	@Descr		varchar(60) OUTPUT,
	@InvtID		varchar(30) OUTPUT,
	@Count		integer OUTPUT
as
	-- Get the count of customer specific records first
	select	@Count = count(*)
	from	ItemXRef (NOLOCK)
	where	AlternateID = @AlternateID
	and	EntityID = @EntityID
	and	AltIDType = 'C'

	-- Return the data if there is only one record
	if @Count = 1
	begin
		-- Get the one customer specific record
		select	top 1
			@Descr = ltrim(rtrim(Descr)),
			@InvtID = ltrim(rtrim(InvtID))
		from	ItemXRef (NOLOCK)
		where	AlternateID = @AlternateID
		and	EntityID = @EntityID
		and	AltIDType = 'C'

		--select 'Customer', @Descr, @InvtID, @Count
		return 1
	end

	-- Return failure if more than one record was found
	if @Count > 1
	begin
		set @Descr = ''
		set @InvtID = ''
		--select 'Customer', @Count
		return 0	--Failure
	end
	else
	begin	-- If no records were found
		-- Get the count non-customer specific records
		select	@Count = count(*)
		from	ItemXRef (NOLOCK)
		where	AlternateID = @AlternateID
		And	AltIDType in ('G','S','M','K','U','E','I','D','P','B')

		-- Return the data if there is only one record
		if @Count = 1
		begin
			-- Get the one non-customer specific record
			select	top 1
				@Descr = ltrim(rtrim(Descr)),
				@InvtID = ltrim(rtrim(InvtID))
			from	ItemXRef (NOLOCK)
			where	AlternateID = @AlternateID
			And	AltIDType in ('G','S','M','K','U','E','I','D','P','B')

			--select 'Non-Customer', @Descr, @InvtID, @Count
			return 1
		end
		else
		begin	-- Return failure otherwise
			set @Descr = ''
			set @InvtID = ''
			--select 'Non-Customer', @Count
			return 0	--Failure
		end
	end
GO
