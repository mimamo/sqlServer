USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_GetAddr]    Script Date: 12/21/2015 15:49:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_GetAddr]
	@ShiptoType	varchar(1),
	@Key1		varchar(20),
	@Key2		varchar(20)
as
	if (@ShiptoType = 'C') -- Customer
	begin
		select	Addr1,
			Addr2,
			Attn,
			City,
			Country,
			Name,
			Phone,
			State,
			Zip
		from	SOAddress
		where	CustID = @Key1
		  and	ShiptoID = @Key2
	end
	else
	if (@ShiptoType = 'O') -- Other
	begin
		select	Addr1,
			Addr2,
			Attn,
			City,
			Country,
			Name,
			Phone,
			State,
			Zip
		from	Address
		where	AddrID = @Key1
	end
	else
	if (@ShiptoType = 'S') -- Site
	begin
		select	Addr1,
			Addr2,
			Attn,
			City,
			Country,
			CAST(Name AS Varchar(60)),
			Phone,
			State,
			Zip
		from	Site
		where	SiteID = @Key1
	end
	else
	if (@ShiptoType = 'V') -- Vendor
	begin
		select	Addr1,
			Addr2,
			Attn,
			City,
			Country,
			Name,
			Phone,
			State,
			Zip
		from	Vendor
		where	VendID = @Key1
	end
	else
	begin
		select	'Addr1' = '',
			'Addr2' = '',
			'Attn' = '',
			'City' = '',
			'Country' = '',
			'Name' = '',
			'Phone' = '',
			'State' = '',
			'Zip' = ''
	end
GO
