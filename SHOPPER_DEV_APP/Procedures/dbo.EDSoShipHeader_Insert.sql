USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSoShipHeader_Insert]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSoShipHeader_Insert]  @SHIPPERID VARCHAR(10), @CPNYID VARCHAR(10), @PROG  VARCHAR(8), @USER VARCHAR(10)
AS
Insert into EDSOShipHeader Values(' ', @CPNYID, GetDate(),@PROG,@USER,0,' ','1/1/1900',0 ,' ',GetDate(),@PROG,@USER ,'NONE', ' ',' ',0,0,0,0,'1/1/1900','1/1/1900',0,0,' ',' ',0,@SHIPPERID, ' ', '1/1/1900',' ',' ',' ',0,0,'1/1/1900', ' ', '1/1/1900', 0,' ',0,' ',0,' ', DEFAULT)
GO
