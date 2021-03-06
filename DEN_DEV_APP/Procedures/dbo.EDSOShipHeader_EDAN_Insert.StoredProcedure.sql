USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_EDAN_Insert]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOShipHeader_EDAN_Insert]
	@CPNYID VARCHAR(10),
	@SHIPPERID VARCHAR(15),
	@PROG  VARCHAR(8),
	@USER VARCHAR(10)
AS
	DECLARE @RecordExists smallint, @SetupCount smallint
	SELECT @SetupCount = 0, @RecordExists = 0

	SELECT @RecordExists = Count(*) FROM EDSOShipHeader (NOLOCK) WHERE CpnyID = @CPNYID AND ShipperID = @SHIPPERID
	SELECT @SetupCount = Count(*) FROM EDSetup (NOLOCK) FULL Outer Join ANSetup (NOLOCK) On EDSetup.SetupID = ANSetup.SetupID

	IF @RecordExists = 0 AND @SetupCount > 0
	BEGIN
		INSERT INTO EDSOShipHeader
		Values(' ', @CPNYID, GetDate(),@PROG,@USER,0,' ','1/1/1900',0 ,' ',
			GetDate(),@PROG,@USER ,'NONE', ' ',' ',0,0,0,0,
			'1/1/1900','1/1/1900',0,0,' ',' ',0,@SHIPPERID, ' ', '1/1/1900',
			' ',' ',' ',0,0,'1/1/1900', ' ', '1/1/1900', 0,' ',0,' ',0,' ', DEFAULT)
	END
GO
