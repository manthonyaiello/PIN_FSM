--
--  Generated by RecordFlux 0.5.0-pre on 2021-07-25
--
--  Copyright (C) 2018-2021 Componolit GmbH
--
--  This file is distributed under the terms of the GNU Affero General Public License version 3.
--

pragma Style_Checks ("N3aAbcdefhiIklnOprStux");
pragma Warnings (Off, "redundant conversion");
with RFLX.RFLX_Types;
with RFLX.PIN_FSM;
with RFLX.PIN_FSM.Request;
with RFLX.PIN_FSM.Config;

generic
   with function User_Channel_Has_Data return Boolean;
   with procedure User_Channel_Read (Buffer : out RFLX_Types.Bytes; Length : out RFLX_Types.Length);
   with function Config_Channel_Has_Data return Boolean;
   with procedure Config_Channel_Read (Buffer : out RFLX_Types.Bytes; Length : out RFLX_Types.Length);
   with procedure Upstream_Channel_Write (Buffer : RFLX_Types.Bytes);
package RFLX.PIN_FSM.Authentication with
  SPARK_Mode,
  Initial_Condition =>
    Uninitialized
is

   pragma Unreferenced (Config_Channel_Has_Data);

   pragma Unreferenced (User_Channel_Has_Data);

   function Uninitialized return Boolean;

   function Initialized return Boolean;

   function Active return Boolean;

   procedure Initialize with
     Post =>
       Initialized
       and Active;

   procedure Finalize with
     Pre =>
       Initialized,
     Post =>
       Uninitialized
       and not Active;

   pragma Warnings (Off, "subprogram ""Tick"" has no effect");

   procedure Tick with
     Pre =>
       Initialized,
     Post =>
       Initialized;

   pragma Warnings (On, "subprogram ""Tick"" has no effect");

   pragma Warnings (Off, "subprogram ""Run"" has no effect");

   procedure Run with
     Post =>
       Uninitialized;

   pragma Warnings (On, "subprogram ""Run"" has no effect");

private

   use type RFLX_Types.Index;

   type Session_State is (S_Initialize, S_Setup, S_Locked, S_Disabled, S_Authenticated, S_Update, S_Forwarding, S_Error);

   State : Session_State := S_Initialize;

   PIN : PIN_FSM.PIN;

   Retries : PIN_FSM.Retries;

   Max_Retries : PIN_FSM.Retries;

   Request_Ctx : PIN_FSM.Request.Context;

   Config_Ctx : PIN_FSM.Config.Context;

   function Uninitialized return Boolean is
     (not PIN_FSM.Request.Has_Buffer (Request_Ctx)
      and not PIN_FSM.Config.Has_Buffer (Config_Ctx));

   function Initialized return Boolean is
     (Request.Has_Buffer (Request_Ctx)
      and then Request_Ctx.Buffer_First = RFLX_Types.Index'First
      and then Request_Ctx.Buffer_Last = RFLX_Types.Index'First + 4095
      and then Config.Has_Buffer (Config_Ctx)
      and then Config_Ctx.Buffer_First = RFLX_Types.Index'First
      and then Config_Ctx.Buffer_Last = RFLX_Types.Index'First + 4095);

   function Active return Boolean is
     (State /= S_Error);

end RFLX.PIN_FSM.Authentication;
