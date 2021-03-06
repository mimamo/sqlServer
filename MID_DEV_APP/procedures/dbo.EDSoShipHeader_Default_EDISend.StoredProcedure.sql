USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSoShipHeader_Default_EDISend]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSoShipHeader_Default_EDISend] @InCpnyId char(10),@InShipperId char(15) AS
Declare @CustId char(15)
declare @SetEDI810 int
set nocount on
-- Get customer, need to find defaults for the customer
select @CustId = (Select CustId from SOShipHeader where CpnyId = @InCpnyId and ShipperId = @InShipperId)
-- See what outbound transactions exist, of 0, then 0 will be put in Set vars, if > 0, then number, to be corrected below
select @SetEDI810 = (select count(*) from edoutbound where custid = @CustId and trans in ('810','880'))
-- Following is to prevent getting number > 1, 1 is LTRUE in Sol code
if @SetEDI810 > 1
  select @SetEDI810 = (select 1)
-- Have the values to update to, so now apply them
update SOShipHeader set EDI810 = @SetEDI810 where CpnyId = @InCpnyId and ShipperId = @InShipperId
set nocount off
GO
