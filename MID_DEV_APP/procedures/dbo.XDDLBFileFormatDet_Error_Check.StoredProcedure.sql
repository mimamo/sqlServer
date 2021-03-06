USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDLBFileFormatDet_Error_Check]    Script Date: 12/21/2015 14:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDLBFileFormatDet_Error_Check]
   @LookUpType		smallint,
   @LookUpValue		varchar(30)

AS

	if @LookUpType = 1	-- Bank Account Number
		select count(*) from xdddepositor (nolock) 
		where vendcust = 'C' 
			and (rtrim(bankacct) = rtrim(@LookupValue)
			or rtrim(lbbankacct) = rtrim(@LookupValue))
			
	if @LookUpType = 2	-- Bank Transit Routing
		select count(*) from xdddepositor (nolock) 
		where vendcust = 'C'
			and (rtrim(banktransit) = rtrim(@LookupValue)
			or rtrim(lbbanktransit) = rtrim(@LookupValue))

	if @LookUpType = 5	-- Company Cash Account
		select count(*) from xddbank (nolock) where acct = @LookupValue

	if @LookUpType = 6	-- Customer ID
		select count(*) from customer (nolock) where custid = @LookupValue

	if @LookUpType = 7	-- Customer Name
		select count(*) from customer (nolock) where name = @LookupValue

	if @LookUpType = 18	-- Invoice Number
		select count(*) from ardoc (nolock) where refNbr = @LookupValue
GO
