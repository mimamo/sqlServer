USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SH_Lookup_Detail]    Script Date: 12/21/2015 13:56:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SH_Lookup_Detail]
	@CpnyID varchar(10),
	@CustID varchar(15),
	@CustOrdNbr varchar(25),
	@Status varchar(1),
	@InvtID varchar(30),
	@SiteID varchar(10),
	@InvcNbr varchar(10),
	@OrdNbr varchar(15),
	@OrdDateFrom varchar(10),
	@OrdDateTo varchar(10)
AS
	DECLARE	@sql 	VARCHAR(8000),
		@wherestr VARCHAR(3000)

	SELECT @wherestr = ' 1 = 1 '

	IF PATINDEX('%[%,_]%', @CpnyID) = 0 -- @CpnyID <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.CpnyID = ' + QUOTENAME(@CpnyID, '''')
	ELSE IF @CpnyID <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.CpnyID LIKE ' + QUOTENAME(@CpnyID, '''')
 	IF PATINDEX('%[%,_]%', @CustID) = 0 -- @CustID <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.CustID = ' + QUOTENAME(@CustID, '''')
	ELSE IF @CustID <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.CustID LIKE ' + QUOTENAME(@CustID, '''')

	IF PATINDEX('%[%,_]%', @CustOrdNbr) = 0 -- @custordnbr <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.CustOrdNbr = ' + QUOTENAME(@CustOrdNbr, '''')
	ELSE IF @CustOrdNbr <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.CustOrdNbr LIKE ' + QUOTENAME(@CustOrdNbr, '''')
 	IF PATINDEX('%[%,_]%', @Status) = 0 -- @status <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.Status = ' + QUOTENAME(@Status, '''')
	ELSE IF @Status <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.Status LIKE ' + QUOTENAME(@Status, '''')
 	IF PATINDEX('%[%,_]%', @InvtID) = 0 -- @invtid  <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipLine.InvtID = ' + QUOTENAME(@InvtID, '''')
	ELSE IF @InvtID <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipLine.InvtID LIKE ' + QUOTENAME(@InvtID, '''')
 	IF PATINDEX('%[%,_]%', @SiteID) = 0 -- @siteid  <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.SiteID = ' + QUOTENAME(@SiteID, '''')
	ELSE IF @SiteID <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.SiteID LIKE ' + QUOTENAME(@SiteID, '''')
 	IF PATINDEX('%[%,_]%', @InvcNbr) = 0 -- @invcnbr  <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.InvcNbr = ' + QUOTENAME(@InvcNbr, '''')
	ELSE IF @InvcNbr <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.InvcNbr LIKE ' + QUOTENAME(@InvcNbr, '''')
 	IF PATINDEX('%[%,_]%', @OrdNbr) = 0 -- @ordnbr  <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.OrdNbr = ' + QUOTENAME(@OrdNbr, '''')
	ELSE IF @OrdNbr <> '%'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.OrdNbr LIKE ' + QUOTENAME(@OrdNbr, '''')
 	IF @OrdDateFrom <> '01/01/1900'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.OrdDate >= ' + QUOTENAME(@OrdDateFrom,'''')

	IF @OrdDateTo <> '01/01/2079'
		SELECT @wherestr = @wherestr + ' AND SOShipHeader.OrdDate <= ' + QUOTENAME(@OrdDateTo,'''' )
 	SELECT @sql = '
		SELECT 	SOShipLine.*,
			SOShipHeader.CustID,
			SOShipHeader.ShipName,
			SOShipHeader.ShipViaID,
			SOShipHeader.SiteID,
			SOShipHeader.TransitTime,
			SOShipHeader.AdminHold,
			SOShipHeader.WeekendDelivery,
			SOShipHeader.ShipDateAct,
			SOShipHeader.ShipDatePlan
		FROM 	SOShipLine WITH (NOLOCK)
		INNER
		JOIN 	SOShipHeader WITH (NOLOCK)
		  ON 	SOShipHeader.CpnyID = SOShipLine.CpnyID
		 AND 	SOShipHeader.ShipperID = SOShipLine.ShipperID
		where	' + @wherestr + ' ORDER BY SOShipHeader.CpnyID, SOShipHeader.OrdNbr'
 	EXEC (@sql)
GO
